class AddColumnToMessage < ActiveRecord::Migration
  def change
    add_column :messages,:is_read,:boolean,:default => false
    add_index :messages, :is_read
  end
end
