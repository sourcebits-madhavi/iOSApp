class AddIsPointsAddedToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :isPoints, :boolean
  end
end
