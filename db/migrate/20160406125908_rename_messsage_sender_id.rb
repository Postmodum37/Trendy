class RenameMesssageSenderId < ActiveRecord::Migration
  def change
    rename_column :messages, :sender_id, :recipient_id
  end
end
