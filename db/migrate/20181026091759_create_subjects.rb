class CreateSubjects < ActiveRecord::Migration[5.2]
  def change
    create_table :subjects do |t|
      t.string :title
      t.text :description
      t.integer :time_traning

      t.timestamps
    end
  end
end
