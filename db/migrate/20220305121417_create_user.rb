class CreateUser < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, unique: true
      t.string :email, null: false, unique: true
      t.string :first_name
      t.string :last_name
      t.string :password_digest, null: false
      t.timestamps
    end
  end
end
