class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.string :identity, null: false, index: true
      t.string :email, null: false, index: true
      t.string :subject, null: false
      t.text :content, null: false
      t.timestamps
    end
  end
end
