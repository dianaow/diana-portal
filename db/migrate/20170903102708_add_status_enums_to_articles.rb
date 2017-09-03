class AddStatusEnumsToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :status, :integer, default:0
  end
end
