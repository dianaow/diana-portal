class AddDefaultImpressionsCountToArticles < ActiveRecord::Migration[5.1]
  def change
     change_column :articles, :impressions_count, :integer, :default => 0
  end
end
