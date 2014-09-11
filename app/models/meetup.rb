class Meetup < ActiveRecord::Base
  has_many :participants
  validates :name, presence: true
  validates :location, presence: true
  validates :description, presence: true
end
