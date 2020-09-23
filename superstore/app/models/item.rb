class Item < ActiveRecord::Base
  validates_presence_of :title, :price, :description
  belongs_to :user
end