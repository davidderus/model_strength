class AddScoreToProduct < ActiveRecord::Migration
  def change
    add_column :products, :score, :integer
  end
end
