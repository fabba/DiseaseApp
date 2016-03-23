class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :country
  has_many :comments, :dependent => :destroy
  has_many :review_logs, :dependent => :destroy
    
  validates :title, presence: true, length: {minimum: 5}
  validates :body, presence: true, length: {minimum: 20}
end
