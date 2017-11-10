class AddImpressionsCountToCategories < ActiveRecord::Migration[5.1]
  def change
     add_column :categories, :impressions_count, :integer, :default => 0
  end
end
