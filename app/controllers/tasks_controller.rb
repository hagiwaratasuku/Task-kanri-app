class TasksController < ApplicationController
  def index
    @tasks = task.all
  end
  
  def create
  end
end
