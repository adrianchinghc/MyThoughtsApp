class ThoughtsController < ApplicationController
	include SessionsHelper
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user,   only: :destroy

	def index
		@thoughts = current_user.thoughts.paginate(page: params[:page], per_page: 10)
	end

	def new
		if logged_in?
			@thought = current_user.thoughts.build 
			@feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
		end
	end

	def create
		@thought = current_user.thoughts.build(thought_params)
    if @thought.save
      flash[:success] = "Thought successfully saved!"
      redirect_to thoughts_path
    else
    	@feed_items = []
    	render :new
    end
	end

	def destroy
		@thought.destroy
    flash[:success] = "Thought successfully deleted"
    redirect_to request.referrer || root_url
	end

	private

    def thought_params
      params.require(:thought).permit(:content)
    end

    def correct_user
      @thought = current_user.thoughts.find_by(id: params[:id])
      redirect_to root_url if @thought.nil?
    end
end
