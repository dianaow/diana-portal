class AddReadAtToPersonalMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :personal_messages, :read_at, :datetime
  end
end
