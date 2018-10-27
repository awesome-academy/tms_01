class CreateUserSubjects < ActiveRecord::Migration[5.2]
  def change
    create_table :user_subjects do |t|
      t.integer :status, default: 0
      t.references :user_course, foreign_key: true
      t.references :course_subject, foreign_key: true

      t.timestamps
    end
  end
end
