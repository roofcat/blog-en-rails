class ArticlesController < ApplicationController
	#before_action :validate_user, except: [:show, :index]
	#before_action :authenticate_user!, only: [:create, :new, :edit]
	before_action :authenticate_user!, except: [:show, :index]
	# Setear variable @article
	before_action :set_article, except: [:index, :new, :create]

	def index
		@articles = Article.all
	end

	def show
		@article.update_visits_count
	end

	def new
		@article = Article.new
	end

	def edit
	end

	def create
		#@article = Article.new(title: params[:article][:title], body: params[:article][:body])
		@article = current_user.articles.new(article_params)

		if @article.save
			redirect_to @article
		else
			render :new
		end
	end

	def destroy
		@article.destroy
		redirect_to articles_path
	end

	def update
		if @article.update(article_params)
			redirect_to @article
		else
			render :edit
		end
	end

	private

	# def validate_user
	# 	redirect_to new_user_session_path, notice: "Necesitas iniciar sesión"
	# end

	def set_article
		@article = Article.find(params[:id])
	end

	def article_params
		params.require(:article).permit(:title, :body)
	end
end