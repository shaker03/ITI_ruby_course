class ArticlesController < ApplicationController

  #block users from doing anything unless logged in
  before_action :authenticate_user!

  #set the article for actions that need it (show, edit, update, destroy, report)
  before_action :set_article, only: %i[ show edit update destroy report ]

  #block users from editing/deleting articles they don't own
  before_action :authorize_user!, only: %i[ edit update destroy ]

  #get all public articles
  def index
    @articles = Article.where(is_archived: false)
  end

  #get owner articles including archived ones
  def my_articles
    @articles = current_user.articles
  end

  #get article by id
  def show
    # reject if the article archived and the current user isn't the owner
    unless !@article.is_archived? || (user_signed_in? && @article.user == current_user)
      redirect_to articles_path, alert: "You are not authorized to view this archived article."
    end
  end

  def new
    @article = current_user.articles.build
  end

  def edit
  end

  #create a new article with the current user as the owner
  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to article_url(@article), notice: "Article created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      redirect_to article_url(@article), notice: "Article updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_url, notice: "Article destroyed."
  end

  # report an article (increment the reports_count and trigger archival if needed)
  def report
    if @article.user != current_user
      # manually add and save to trigger the before_save archival logic
      @article.reports_count += 1

      if @article.save
        redirect_to articles_path, notice: "Article reported."
      else
        redirect_to articles_path, alert: "Could not report article."
      end
    else
      redirect_to @article, alert: "You cannot report your own article."
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def authorize_user!
    # If the article's owner is not the current user, block access
    if @article.user != current_user
      redirect_to articles_path, alert: "You are not authorized to edit this article."
    end
  end

  # allowed parameters for creating/updating articles
  def article_params
    params.require(:article).permit(:title, :body, :is_archived, :image)
  end
end
