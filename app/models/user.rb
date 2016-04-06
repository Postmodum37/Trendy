class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true, length: { minimum: 4, maximum: 16}, uniqueness: true
  has_many :links
  has_many :conversations, :foreign_key => :sender_id
  has_many :comments
  has_many :sent_messages, foreign_key: :user_id, class_name: 'Message'
  has_many :recieved_messages, foreign_key: :recipient_id, class_name: 'Message'

  scope :exclude_self, -> term { where.not(id: term)  }

  def has_unread?
    return true if recieved_messages.where(seen: false).count > 0
    return false
  end
end
