class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.string :name, null: false
      t.text :body, null: false
      t.string :email, null: false
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
