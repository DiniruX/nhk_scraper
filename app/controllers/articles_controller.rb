require 'open-uri'
require 'nokogiri'
require 'time'

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @articles = Article.all
  end

  def show; end

  def new
    @article = Article.new
  end

  def edit; end

  def create
    @article = Article.new(article_params)

    begin
      doc = Nokogiri::HTML(URI.open(@article.url))

      # Scrape elements (adjust if NHK layout changes)
      title = doc.at_css('h1')&.text&.strip
      time_str = doc.at_css('.content--meta-time')&.text&.strip
      content_blocks = doc.css('.content--body p')

      @article.title = title || "Title not found"
      @article.published_at = time_str ? Time.parse(time_str) : Time.now
      @article.content = content_blocks.map(&:text).join("\n\n")

      if @article.save
        redirect_to @article, notice: 'Article scraped and saved!'
      else
        render :new
      end

    rescue => e
      @article.errors.add(:base, "Scraping failed: #{e.message}")
      render :new
    end
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.'
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:url)
  end
end