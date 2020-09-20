class TasksController < ApplicationController
  before_action :set_user
  before_action :set_task, only: [:destroy, :edit,]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :admin_user, only: :destroy
  
  def index
    @tasks = @user.tasks.order(created_at: :desc)
   
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = @user.tasks.build(task_params)
    if @task.save
      flash[:success] = "タスクを新規作成しました。"
      redirect_to user_tasks_url @user
    else
      render :new
    end
  end
  
  def edit
    @task = Task.find(params[:id])
  end
  
  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      flash[:success] = "タスクを更新しました。"
      redirect_to user_tasks_url @user
    else
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    flash[:success] = "#{@task.name}のデータを削除しました"
    redirect_to user_tasks_url @user
  end
  
  private
  
    def task_params
      params.require(:task).permit(:name, :description)
    end
    
    def set_user
      @user = User.find(params[:user_id])
    end
    
    def set_task
      unless @task = @user.tasks.find(params[:id])
        flash[:danger] = "権限がありません。"
        redirect_to user_tasks_url @user
      end
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
      end
    end
    
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
    
end
