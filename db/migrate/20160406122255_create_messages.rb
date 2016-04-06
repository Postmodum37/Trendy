class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.text :message_text
      t.string :message_heading
      t.boolean :seen, default: false
      t.timestamps null: false
    end
  end
end
