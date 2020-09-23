class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :username, :email, :location
  validates :username, uniqueness: true
  has_many :items
  has_many :messages
end
