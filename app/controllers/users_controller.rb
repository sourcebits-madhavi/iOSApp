class UsersController < ApplicationController
  before_filter :restrict_access, :except => [:create]

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

  def claim

      claimed_user_all = Invitation.all

      id = params[:user][:fb_id]

      if claimed_user_all.empty?

        render :json => 'empty table'

      else
         
         @accept_array = []
         claimed_user_all.each do |invitation|

           if id == invitation.fb_id
              puts "accept values #{invitation.is_accept}"
              @accept_array.push(invitation.is_accept)
           end 

         end

         if @accept_array.length != 0
            render :json =>  "claiming points are"
         else
            render :json => 'no invitations'
         end

      end

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
