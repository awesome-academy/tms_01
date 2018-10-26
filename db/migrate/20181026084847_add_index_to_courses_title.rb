class AddIndexToCoursesTitle < ActiveRecord::Migration[5.2]
  def change
    add_index :courses, :title, unique: true
  end
end
