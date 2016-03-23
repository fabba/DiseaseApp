class Message < ActiveRecord::Base
  belongs_to :receiver, :class_name => "User"
  belongs_to :sender, :class_name => "User"
  
  validates :title, presence: true, length: {minimum: 3}
  validates :body, presence: true, length: {minimum: 5}
end
