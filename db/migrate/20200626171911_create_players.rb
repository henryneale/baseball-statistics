class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :name
      t.float :avg
      t.integer :hr
      t.integer :rbi
      t.integer :runs
      t.integer :sb
      t.float :ops

      t.timestamps
    end
  end
end
