class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :receiver_id
      t.integer :sender_id
      t.string :title
      t.text :body
      t.boolean :viewed

      t.timestamps
    end
  end
end
