class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.datetime :sign_up_start_date
      t.string :title, null: false
      t.string :event_email
      t.string :website
      t.string :description, null: false
      t.string :country, null: false
      t.string :city, null: false
      t.text :dance_types, array: true, default: []

      t.timestamps
    end
  end
end
