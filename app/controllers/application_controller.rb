class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def logged_in_user
    return if logged_in?
    flash[:danger] = t "controllers.users.pls_log_in"
    redirect_to login_path
  end

  def authenticate_supervisor!
    redirect_to(login_path) unless current_user.supervisor?
  end

  def load_subjects_of_course
    @subjects = CourseSubject.subjects_of_course @course.id
  end

  def load_trainees
    @trainees = UserCourse.user_of_course_by_role @course.id,
      User.trainee
  end

  def load_supervisors
    @supervisors = UserCourse.user_of_course_by_role @course.id,
      User.supervisor
  end

  def load_tasks
    @tasks = @subject.tasks.latest
  end
end
