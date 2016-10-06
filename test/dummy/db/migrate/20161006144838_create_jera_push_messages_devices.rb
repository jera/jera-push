class CreateJeraPushMessagesDevices < ActiveRecord::Migration
  def change
    create_table :jera_push_messages_devices do |t|
      t.references :device, index: true, foreign_key: true
      t.references :message, index: true, foreign_key: true
      t.string :status

      t.timestamps null: false
    end

    add_index :jera_push_messages_devices, [:device_id, :message_id], unique: true, name: :jera_push_index_messages_id_devices_id
  end
end
