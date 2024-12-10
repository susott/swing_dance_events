class AddPublishedToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :published, :boolean, default: false,  null: false
    add_reference :events, :parent_event_id, foreign_key: { to_table: :events }
  end
end
