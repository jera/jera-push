class CreateJeraPushMessages < ActiveRecord::Migration
  def change
    create_table :jera_push_messages do |t|
      t.text :content
      t.string :status

      t.timestamps null: false
    end
  end
end
