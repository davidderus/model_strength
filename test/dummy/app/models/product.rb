class Product < ActiveRecord::Base
  acts_as_strength :text, :description
end
