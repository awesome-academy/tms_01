class AddIndexToSubjectsTitle < ActiveRecord::Migration[5.2]
  def change
    add_index :subjects, :title, unique: true
  end
end
