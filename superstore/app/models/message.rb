class Message < ActiveRecord::Base
  validates_presence_of :content, :recipient
  belongs_to :user
end
