class MoviesController < ApplicationController
  before_action :set_ratings, only: [:index, :show]

  def show
    @movie = Movie.find(params[:id])
  end

  def index
    @movies = Movie.with_ratings(@selected_ratings.keys)

    if params[:sort_column] == 'title'
      @movies = @movies.order(:title)
    elsif params[:sort_column] == 'release_date'
      @movies = @movies.order(:release_date)
    end
  end

  def new
    render 'new'
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def set_ratings
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || @all_ratings
    session[:ratings] = @selected_ratings
  end

  def self.with_ratings(ratings)
    where(rating: ratings)
  end

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end


