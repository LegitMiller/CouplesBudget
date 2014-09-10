class CreateEnvelopes < ActiveRecord::Migration
  def change
    create_table :envelopes do |t|
      t.string :name
      t.string :color
      t.string :icon
      t.integer :precent
      t.integer :cash
      t.integer :user_id

      t.timestamps
    end
  end
end
