class Meetup < ActiveRecord::Base
  has_many :participants
  has_many :users, through: :participants
  has_many :commentslists
  has_many :comments, through: :commentslists

  validates :name, presence: true
  validates :location, presence: true
  validates :description, presence: true
end
