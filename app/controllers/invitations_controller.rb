class InvitationsController < ApplicationController
  # GET /invitations
  # GET /invitations.json
  before_filter :restrict_access

  def index
    @invitations = Invitation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invitations }
    end
  end

  # GET /invitations/1
  # GET /invitations/1.json
  def show
    @invitation = Invitation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invitation }
    end
  end

  # GET /invitations/new
  # GET /invitations/new.json
  def new
    @invitation = Invitation.new
  end

  # GET /invitations/1/edit
  def edit
    @invitation = Invitation.find(params[:id])
  end

  # POST /invitations
  # POST /invitations.json
  def create

      user = params[:user]

      from_id = user[:fb_id]

      existing_fb_user = User.find_by_fb_id(from_id)

      if existing_fb_user
        
        user_invitations = user[:invitations]
       
        @invitations_array = []

        user_invitations.each do |inv|

            inv[:invitation][:fb_id] = from_id
            inv[:invitation][:is_accept] = false
            inv[:invitation][:isPoints] = false


            @invitation = Invitation.new(inv[:invitation])

            @invitations_array.push(inv[:invitation]) 

            render :json => { :errors => @invitation.errors.full_messages } unless @invitation.save

        end

        @madhu = Invitation.new.getInvitations(@invitations_array)

      else
            render :json => { :errors => "No user found" }
      end
   
  end

  # PUT /invitations/1
  # PUT /invitations/1.json
  def update
    @invitation = Invitation.find(params[:id])

    respond_to do |format|
      if @invitation.update_attributes(params[:invitation])
        format.html { redirect_to @invitation, notice: 'Invitation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to invitations_url }
      format.json { head :no_content }
    end
  end

  private 

  def restrict_access

    api_key = ApiKey.find_by_access_token(params[:access_token])
    head :unauthorized unless api_key
  end
end
