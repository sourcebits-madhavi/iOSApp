class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :iv_fb_id
      t.boolean :is_accept

      t.timestamps
    end
  end
end
