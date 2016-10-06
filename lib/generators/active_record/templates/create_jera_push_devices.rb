class CreateJeraPushDevices < ActiveRecord::Migration
  def change
    create_table :jera_push_devices do |t|
      t.string :token, index: true
      t.string :platform, index: true
      t.integer :resource_id, index: true

      t.timestamps null: false
    end
    add_index :jera_push_devices, [:token, :platform], unique: true
  end
end
