class RemoveRoleFromInvitation < ActiveRecord::Migration
  def up
    remove_column :invitations, :isPoines
  end

  def down
    add_column :invitations, :isPoines, :string
  end
end
