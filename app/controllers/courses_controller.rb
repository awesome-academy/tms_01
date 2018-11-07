class CoursesController < ApplicationController
  layout "users"
  before_action :logged_in_user, :authenticate_supervisor!
  before_action :load_course,
    except: %i(index new create add_member add_subject)
  before_action :load_course_to_add, only: %i(add_member add_subject)
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

  def subject_remaining
    @subjects = Subject.not_in_course @course.id
    respond_to :js
  end

  def add_subject
    subjects_id = params[:subjectsId]
    begin
      CourseSubject.transaction do
        subjects_id.each do |subject_id|
          CourseSubject.create!(course_id: @course.id,
            subject_id: subject_id.to_i)
        end
      end
      load_subjects_of_course
    rescue StandardError
      respond_to do |format|
        format.json do
          render json: {status: 403,
                        message: t("alert.subject_not_found")}
        end
        format.json do
          render json: {status: 404,
                        message: t("alert.course_not_found")}
        end
      end
    end

    respond_to :js
  end

  def delete_member
    @user_course = UserCourse.find_by course_id: @course.id,
      user_id: params[:user_id]
    if @user_course&.destroy
      load_supervisors
      load_trainees
      respond_to :js
    else
      flash[:danger] = t "controllers.courses.del_subject_failed"
      redirect_to course_path(@course)
    end
  end

  def delete_subject
    @course_subject = CourseSubject.find_by course_id: @course.id,
      subject_id: params[:subject_id]
    if @course_subject&.destroy
      load_subjects_of_course
      respond_to :js
    else
      flash[:danger] = t "controllers.courses.del_subject_failed"
      redirect_to course_path(@course)
    end
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
      format.json do
        render json: {status: 404,
                      message: t("alert.course_not_found")}
      end
    end
  end
end
