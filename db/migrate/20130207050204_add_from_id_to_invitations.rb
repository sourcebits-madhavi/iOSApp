class AddFromIdToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :fb_id, :string
  end
end
