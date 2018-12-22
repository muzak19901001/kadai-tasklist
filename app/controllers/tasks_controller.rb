class TasksController < ApplicationController
  before_action :set_task, only:[:show, :edit, :update, :destroy]
  
  def index
    @tasks = Task.order(created_at: :desc).page(params[:page]).per(10)
  end  
  
  def show
    set_task
  end  
  
  def new
    @task = Task.new
  end  
  
  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = 'タスクが正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが投稿されませんでした'
      render :new
    end
  end  
  
  def edit
      set_task
  end  
  
  def update
     set_task
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクは正常に更新されませんでした'
      render :new
    end
  end  
  
  def destroy
     set_task
    @task.destroy
    
    flash[:success] = 'タスクが正常に削除されました'
    redirect_to tasks_url
  end  
  
  private
  
  def set_task
     @task = Task.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
end
