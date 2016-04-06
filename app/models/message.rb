class Message < ActiveRecord::Base
  belongs_to :user
  validates :message_heading, :message_text, :recipient_id, presence: true
end
