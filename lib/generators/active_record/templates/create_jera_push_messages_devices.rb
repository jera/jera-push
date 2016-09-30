class CreateJeraPushMessagesDevices < ActiveRecord::Migration
  def change
    create_table :jera_push_messages_devices do |t|
      t.references :jera_push_device, index: true, foreign_key: true
      t.references :jera_push_message, index: true, foreign_key: true
      t.string :status

      t.timestamps null: false
    end

    add_index :jera_push_messages_devices, [:jera_push_device_id, :jera_push_message_id], unique: true, name: :jera_push_index_messages_id_devices_id
  end
end
