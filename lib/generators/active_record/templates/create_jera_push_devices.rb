class CreateJeraPushDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :jera_push_devices do |t|
      t.string :token, index: true
      t.string :platform, index: true
      t.references :pushable, polymorphic: true, index: true

      t.timestamps null: false
    end
    add_index :jera_push_devices, [:token, :platform], unique: true
  end
end
