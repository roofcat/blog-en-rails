class ArticlesController < ApplicationController
	#before_action :validate_user, except: [:show, :index]
	#before_action :authenticate_user!, only: [:create, :new, :edit]
	before_action :authenticate_user!, except: [:show, :index]
	# Setear variable @article
	before_action :set_article, except: [:index, :new, :create]
	before_action :authenticate_editor!, only: [:new, :create, :update]
	before_action :authenticate_admin!, only: [:destroy, :publish]

	# GET /articles
	def index
		#Primera llama "Select * From articles"
		#@articles = Article.all
		# Llamado del scopes
		# @articles = Article.publicados.ultimos
		@articles = Article.paginate(page: params[:page], per_page:5).publicados.ultimos
	end

	# GET /articles/:id
	def show
		@article.update_visits_count
		@comment = Comment.new
	end

	# GET /articles/new
	def new
		@article = Article.new
		@categories = Category.all
	end

	def edit
	end

	# POST /articles
	def create
		#@article = Article.new(title: params[:article][:title], body: params[:article][:body])
		@article = current_user.articles.new(article_params)
		@article.categories = params[:categories]
		#raise params.to_yaml
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

	def publish
		@article.publish!
		redirect_to @article
	end

	private

	# def validate_user
	# 	redirect_to new_user_session_path, notice: "Necesitas iniciar sesión"
	# end

	def set_article
		@article = Article.find(params[:id])
	end

	def article_params
		params.require(:article).permit(:title, :body, :cover, :categories)
	end
end