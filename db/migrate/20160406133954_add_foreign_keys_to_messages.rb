class AddForeignKeysToMessages < ActiveRecord::Migration
  def change
    add_foreign_key :messages, :users, column: :user_id
    add_foreign_key :messages, :users, column: :recipient_id
  end
end
