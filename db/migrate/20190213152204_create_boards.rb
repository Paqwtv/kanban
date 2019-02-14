class CreateBoards < ActiveRecord::Migration[5.2]
  def change
    create_table :boards do |t|
      t.string :uid, null: false, index: true
      t.string :title, null: false

      t.timestamps
    end
  end
end
