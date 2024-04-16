class CreateJeraPushMessagesDevices < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :jera_push_messages_devices do |t|
      t.integer :device_id, index: true
      t.integer :message_id, index: true
      t.string :status
      t.string :error_message
      t.string :firebase_id

      t.timestamps
    end

    add_index :jera_push_messages_devices, [:device_id, :message_id], unique: true, name: :jera_push_index_messages_id_devices_id
  end
end
