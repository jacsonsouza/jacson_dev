class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.timestamps

      t.index :name, unique: true
    end
  end
end
