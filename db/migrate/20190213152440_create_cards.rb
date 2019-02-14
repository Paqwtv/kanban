class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :title, null: false
      t.references :column, index: true

      t.timestamps
    end
  end
end
