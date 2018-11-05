class CoursesController < ApplicationController
  layout "users"
  before_action :logged_in_user, :authenticate_supervisor!
  before_action :load_course, except: %i(index new create)
  before_action :load_subjects_of_course, :load_trainees,
    :load_supervisors, only: :show

  def index
    @courses = Course.latest.paginate page: params[:page],
      per_page: Settings.courses_per_page
  end

  def new
    @course = Course.new
  end

  def show; end

  def create
    @course = Course.new course_params
    if @course.save
      flash[:success] = t "controllers.courses.create_course_success"
      redirect_to courses_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @course.update_attributes course_params
      flash[:success] = t "controllers.courses.update_course"
      redirect_to courses_path
    else
      render :edit
    end
  end

  def destroy
    if @course.destroy
      flash[:warning] = t "controllers.courses.course_deleted"
    else
      flash[:danger] = t "controllers.users.course_not_found"
    end
    redirect_to courses_path
  end

  private

  def course_params
    params.require(:course).permit :title, :description
  end

  def load_course
    @course = Course.find_by id: params[:id]
    return if @course
    flash[:danger] = t "controllers.courses.course_not_found"
    redirect_to courses_path
  end
end
