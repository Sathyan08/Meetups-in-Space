class Comment < ActiveRecord::Base
 belongs_to :user
 belongs_to :meetup

 has_many   :commentslists

end
