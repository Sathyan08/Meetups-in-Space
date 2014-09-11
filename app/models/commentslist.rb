class Commentslist < ActiveRecord::Base
  belongs_to :user
  belongs_to :meetup
  belongs_to :comment
end
