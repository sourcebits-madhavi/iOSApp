class User < ActiveRecord::Base
  attr_accessible :fb_id

  validates :fb_id, :presence => true, :uniqueness => true
  has_many :invitations
  @@acc_token

  def setAccessToken(access_token)
  	@@acc_token = access_token 
  end

  def getAccessToken
  	return @@acc_token
  end
end
