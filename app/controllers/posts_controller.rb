class PostsController < ApplicationController

    before_action :authenticate_user!, only: [:vote]
    before_action :find_post
    respond_to :js, :json, :html
    def index
        # @posts = Post.all
        # @posts = Post.all.sort_by {|post| post.id}.reverse
        if request.path != posts_path
            redirect_to posts_path
        end
        @posts = Post.includes(:likes).all && Post.all.sort_by {|post| post.id}.reverse
    end

    

    def show
        @user = User.find(params[:id])
        @post = @user.posts.build
    end

    def new
        @post = Post.new
        @users = User.all
    end
    
    def create
        @user = User.find(params[:user_id])
        @post = Post.new(post_params)
        @post.user_id = @user.id
        @post.save
        redirect_to user_path(@user)
    end

    def edit
        find_post
        # byebug
    end

    def update
       find_post
       @post.update(params.require(:post).permit(:description))
       redirect_to user_path(@post.user)
    end

    def destroy
        find_post
        @post.destroy
        redirect_to user_path(@post.user)
    end

    def vote 
        if !current_user.liked? @post
            @post.liked_by current_user 
        elsif current_user.liked? @post 
            @post.unliked_by current_user
        end
    end

    private

    def post_params
        params.require(:post).permit(:description, :content, :user_id)
    end

    def find_post
        @post = Post.find(params[:id])
    end
end
