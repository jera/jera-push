class CreateJeraPushMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :jera_push_messages do |t|
      t.text :content
      t.text :broadcast_result
      t.string :status
      t.string :kind
      t.string :topic
      t.string :firebase_id
      t.string :error_message
      t.integer :failure_count, default: 0
      t.integer :success_count, default: 0

      t.timestamps null: false
    end
  end
end
