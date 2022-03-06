class CreateContact < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :name, presence: true
      t.string :number, presence: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
