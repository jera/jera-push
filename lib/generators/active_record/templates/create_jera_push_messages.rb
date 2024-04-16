class CreateJeraPushMessages < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :jera_push_messages do |t|
      t.string :title
      t.text :body
      t.json :data
      t.string :multicast_id
      t.text :broadcast_result
      t.string :status
      t.string :kind
      t.string :topic
      t.string :firebase_id
      t.json :error_message
      t.integer :failure_count, default: 0
      t.integer :success_count, default: 0

      t.timestamps
    end
  end
end
