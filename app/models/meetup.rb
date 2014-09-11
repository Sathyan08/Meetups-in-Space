class Meetup < ActiveRecord::Base
  has_many :participants
  has_many :users, through: :participants
  has_many :comments

  validates :name, presence: true
  validates :location, presence: true
  validates :description, presence: true
end
