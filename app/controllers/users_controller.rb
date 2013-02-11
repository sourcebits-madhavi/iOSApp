class UsersController < ApplicationController
  before_filter :restrict_access, :except => [:create]

  respond_to :json

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new

    @user = User.new

  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create

    existing_user = User.find_by_fb_id( params[:user][:fb_id] )
    exiting_in_invitation =  Invitation.find_by_iv_fb_id( params[:user][:fb_id] ) 

    api_create = ApiKey.create!

    @access_token = api_create[:access_token]

    puts "token  "+@access_token

    User.new.setAccessToken(@access_token)

    if existing_user 

      puts "exiting here"
      @user = existing_user

    elsif exiting_in_invitation

      puts "i have been invited by someone  please create me"
      @user = User.new(params[:user])

      render :json => { :errors => @user.errors.full_messages } unless @user.save

      Invitation.find_by_iv_fb_id( params[:user][:fb_id] ).update_attributes(:is_accept => true)

    else

      puts "i am not existed please create me"
      @user = User.new(params[:user])
      
      render :json => { :errors => @user.errors.full_messages } unless @user.save

    end       

  end

# To claim the points
  def claim

      claimed_user_all = Invitation.all

     # id = params[:user][:fb_id]

      id = params[:id]

      puts "params #{id}"

      @user = User.find_by_fb_id(id)

      existing_points = @user[:points]

      if existing_points == nil

        existing_points = 0

      end

      if claimed_user_all.empty?

        render :json => { :message => "No Record Found" }

      else
         
         @accept_array = []
         @iv_id_array = []

         claimed_user_all.each do |invitation|

           if id == invitation.fb_id && invitation.is_accept == true && invitation.isPoints == false
               
                @accept_array.push(invitation.is_accept)
                @iv_id_array.push(invitation.iv_fb_id)
                        
           end 

         end

         accept_array_length = @accept_array.length

         if accept_array_length != 0

            claim_points = (accept_array_length/3).floor

            puts "Claimed points #{claim_points}"

            i = 0

            while i < claim_points do

              Invitation.find_by_iv_fb_id( @iv_id_array[i] ).update_attributes(:isPoints => true)
              i+=1

            end

            User.find_by_fb_id(id).update_attributes(:points => existing_points+(claim_points*100))

            #respond_with(@user)

            render :json => { :message => "Claimed Points successfully", :points => existing_points+(claim_points*100) }

           
         else

            render :json => { :message => "No one accepted the invitation" }

         end

      end

  end

  def getpoints

    @user  =  User.find_by_fb_id(params[:id])

    respond_with(@user)
    
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  

  private 

  def restrict_access

    api_key = ApiKey.find_by_access_token(params[:access_token])
    head :unauthorized unless api_key
  end
end
