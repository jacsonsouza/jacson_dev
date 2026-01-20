class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.text :short_description
      t.date :start_date, null: false
      t.date :end_date
      t.string :url
      t.string :repository
      t.boolean :favorite, default: false, null: false
      t.belongs_to :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :projects, :name
    add_index :projects, :favorite
    add_index :projects, %i[start_date end_date]
  end
end
