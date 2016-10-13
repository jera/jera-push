class CreateJeraPushMessages < ActiveRecord::Migration
  def change
    create_table :jera_push_messages do |t|
      t.text :content
      t.string :status
      t.integer :failure_count, default: 0
      t.integer :success_count, default: 0

      t.timestamps null: false
    end
  end
end
