class Invitation < ActiveRecord::Base

  attr_accessible :is_accept, :iv_fb_id, :fb_id, :isPoints
  belongs_to :user
  validates :iv_fb_id, :presence => true
  validates :fb_id, :presence => true
  validates_uniqueness_of :iv_fb_id, :scope => :fb_id
  @@invitations = []

	def getInvitations(invitations_array)	
		@@invitations.clear
		invitations_array.each do |i|
			@@invitations.push(i)
		end
	end

	def showInvitations
		return @@invitations
	end
end
