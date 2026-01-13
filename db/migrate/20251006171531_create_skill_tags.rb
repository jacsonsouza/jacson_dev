class CreateSkillTags < ActiveRecord::Migration[8.0]
  def change
    create_table :skill_tags do |t|
      t.belongs_to :skill, null: false, foreign_key: true
      t.belongs_to :tag, null: false, foreign_key: true
      t.timestamps
    end
  end
end
