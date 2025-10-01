class CreateSkills < ActiveRecord::Migration[8.0]
  def change
    create_table :skills do |t|
      t.string :name
      t.belongs_to :user, null: false, foreign_key: true
      t.timestamps

      t.index :name, unique: true
    end
  end
end
