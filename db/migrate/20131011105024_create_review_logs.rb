class CreateReviewLogs < ActiveRecord::Migration
  def change
    create_table :review_logs do |t|
      t.integer :review_id
      t.integer :user_id
      t.boolean :seen
      t.integer :rating
      t.timestamps
    end
  end
end
