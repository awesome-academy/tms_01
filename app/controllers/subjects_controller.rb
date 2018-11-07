class SubjectsController < ApplicationController
  layout "users"
  before_action :logged_in_user, :authenticate_supervisor!
  before_action :load_subject, except: %i(index new create)
  before_action :load_tasks, only: :show

  def index
    @subjects = Subject.latest.paginate page: params[:page],
      per_page: Settings.subjects_per_page
  end

  def new
    @subject = Subject.new
  end

  def show; end

  def create
    @subject = Subject.new subject_params
    if @subject.save
      flash[:success] = t "controllers.subjects.create_subject_success"
      redirect_to subjects_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @subject.update_attributes subject_params
      flash[:success] = t "controllers.subjects.update_subject"
      redirect_to subject_path
    else
      render :edit
    end
  end

  def destroy
    if @subject.destroy
      flash[:warning] = t "controllers.subjects.subject_deleted"
    else
      flash[:danger] = t "controllers.subjects.subject_not_found"
    end
    redirect_to subjects_path
  end

  private

  def subject_params
    params.require(:subject).permit :title, :description
  end

  def load_subject
    @subject = Subject.find_by id: params[:id]
    return if @subject
    flash[:danger] = t "controllers.subjects.subject_not_found"
    redirect_to subjects_path
  end
end
