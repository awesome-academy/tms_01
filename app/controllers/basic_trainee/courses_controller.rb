class BasicTrainee::CoursesController < ApplicationController
  layout "basic_application"
  before_action :load_user_courses, only: :index
  before_action :load_course, only: :show
  before_action :load_subjects_of_course, :load_trainees,
    :load_supervisors, only: :show

  def index; end

  def show; end

  private

  def load_course
    @course = Course.find_by id: params[:id]
    return if @course
    flash[:danger] = t "controllers.courses.course_not_found"
    redirect_to basic_trainee_courses_path
  end
end
