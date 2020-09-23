class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :content
      t.integer :user_id
      t.string :recipient
      t.timestamps null: false
    end
  end
end
