class CreateJeraPushDevices < ActiveRecord::Migration[7.0]
  def change
    create_table :jera_push_devices do |t|
      t.string :token, index: true
      t.string :platform, index: true
      t.integer :resource_id, index: true

      t.timestamps
    end

    add_index :jera_push_devices, [:token, :platform], unique: true
  end
end
