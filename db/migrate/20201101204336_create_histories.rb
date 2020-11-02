class CreateHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :histories do |t|
      t.string :q
      t.string :mode
      t.string :fns

      t.timestamps
    end
  end
end
