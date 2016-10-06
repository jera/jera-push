class CreateJeraPushDevices < ActiveRecord::Migration
  def change
    create_table :jera_push_devices do |t|
      t.string :token, index: true
      t.string :platform, index: true
      t.references :user, foreign_key: true

      t.timestamps null: false
    end
    add_index :jera_push_devices, [:token, :platform], unique: true
  end
end
