class CoursesController < ApplicationController
  layout "users"
  before_action :logged_in_user, :authenticate_supervisor!
  before_action :load_course, except: %i(index new create add_member)
  before_action :load_course_to_add, only: :add_member
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

  def member_remaining
    @users = User.not_in_course @course.id
    respond_to :js
  end

  def add_member
    users_id = params[:usersChecked]
    begin
      UserCourse.transaction do
        users_id.each do |user_id|
          UserCourse.create!(user_id: user_id.to_i, course_id: @course.id)
        end
        load_supervisors
        load_trainees
      end
    rescue StandardError
      respond_to do |format|
        format.json{render json: {status: 403}}
      end
    end

    respond_to :js
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

  def load_course_to_add
    @course = Course.find_by id: params[:courseId]
    return if @course.present?
    respond_to do |format|
      format.json{render json: {status: 404}}
    end
  end
end
