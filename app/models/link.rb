class Link < ActiveRecord::Base
	validates :title, presence: true
	validates :url, presence: true, url: true

	acts_as_votable

	belongs_to :user
	has_many :comments, :dependent => :destroy

end
