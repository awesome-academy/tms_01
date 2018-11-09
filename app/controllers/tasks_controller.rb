class TasksController < ApplicationController
  before_action :load_subject, only: :create

  def create
    @task = @subject.tasks.build task_params
    if @task.save
      load_tasks
      respond_to :js
    else
      flash[:danger] = t "controllers.tasks.create_task_success"
      redirect_to subject_path(@subject)
    end
  end

  private

  def task_params
    params.require(:task).permit :title, :description
  end

  def load_subject
    @subject = Subject.find_by id: params[:subject_id]
    return if @subject
    flash[:danger] = t "controllers.tasks.subject_not_found"
    redirect_to subjects_path
  end
end
