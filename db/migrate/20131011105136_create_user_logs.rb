class CreateUserLogs < ActiveRecord::Migration
  def change
    create_table :user_logs do |t|
      t.integer :user_id
      t.integer :country_id
      t.boolean :visited
      t.boolean :wish
      t.boolean :viewed

      t.timestamps
    end
  end
end
