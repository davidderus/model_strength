class Product < ActiveRecord::Base
  acts_as_strength :name, :description
end
