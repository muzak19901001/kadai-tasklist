class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'タスクが保存されました'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(created_at: :desc).page(params[:page]).per(10)
      flash.now[:danger] = 'タスクの保存に失敗しました'
      render 'toppages/index'
    end
  end  

  def destroy
    @task.destroy
    flash[:success] = 'タスクを削除しました'
    redirect_back(fallback_location: root_path)
  end
  
  def edit
    @task = current_user.tasks.find(params[:id])
  end
  
  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      flash[:success] = 'タスクを編集しました'
      redirect_to root_url
    else
      flash.now[:danger] = 'タスクの編集に失敗しました'
      render 'tasks/edit'
    end
  end
  
  private
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
