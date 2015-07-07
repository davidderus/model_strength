class Product < ActiveRecord::Base
  acts_as_strength :description, :note, exclude: true
end
