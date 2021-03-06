class GroupsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts
  end

  def new
    @group = Group.new
  end

  def edit
    @group = current_user.groups.find(params[:id])
  end

  def create
    @group = current_user.groups.new(group_params)

    if @group.save
      current_user.join!(@group)
      redirect_to groups_path, notice: "New Board is created!"
    else
      render :new
    end
  end

  def update
    @group = current_user.groups.find(params[:id])

    if @group.update(group_params)
      redirect_to groups_path, notice: "Correction is successful!"
    else
      render :edit
    end
  end

  def destroy
    @group = current_user.groups.find(params[:id])
    @group.destroy
    redirect_to groups_path, alert: "The broad is deleted"
  end
end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_memeber_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "Join this board successfully!"
    else
      flash[:notice] = "You are a member already!"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_memeber_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "You have left this borad!"
    else
      flash[:alert] = "You are not a member yet, how can you leave?"
    end

    redirect_to group_path(@group)
  end

private

def group_params
  params.require(:group).permit(:title, :description)
end
