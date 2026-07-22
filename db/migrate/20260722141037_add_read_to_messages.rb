class AddReadToMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :read, :boolean, default: false
  end
end
