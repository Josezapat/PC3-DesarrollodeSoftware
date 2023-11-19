class MoviesController < ApplicationController
  before_action :set_ratings, only: [:index, :show]

  def show
    @movie = Movie.find(params[:id])
  end

  def index
    @movies = Movie.all
  
    # Guardar o restaurar configuraciones de clasificación y filtrado
    if params[:sort_column]
      # Guardar nuevas configuraciones en la sesión
      session[:sort_column] = params[:sort_column] if params[:sort_column]
    else
      # Restaurar configuraciones desde la sesión si los parámetros no están presentes
      params[:sort_column] = session[:sort_column]
    end
  
    # Aplicar clasificación y filtrado basado en parámetros o valores de sesión
    apply_sorting_and_filtering
  end
  
  private
  
  def apply_sorting_and_filtering
    @movies = @movies.order(params[:sort_column]) if params[:sort_column]
    if @selected_ratings.is_a?(Hash)
      # Si es un Hash, usa las claves del hash.
      @movies = @movies.with_ratings(@selected_ratings.keys)
    elsif @selected_ratings.is_a?(Array)
      # Si es un Array, úsalo directamente.
      @movies = @movies.with_ratings(@selected_ratings)
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
  
    if params[:ratings]
      @selected_ratings = params[:ratings].keys
      session[:ratings] = @selected_ratings
    elsif params[:commit] == "Refresh Page" && params[:ratings].blank?
      # Si se presionó "Refresh Page" pero no hay ratings seleccionados, seleccionar todos
      @selected_ratings = @all_ratings.to_h { |rating| [rating, 1] }
      session[:ratings] = @selected_ratings
    elsif session[:ratings]
      # Cargar de la sesión si no se ha presionado "Refresh Page"
      @selected_ratings = session[:ratings]
    else
      # Si no hay parámetros ni valores en la sesión, seleccionar todos los ratings
      @selected_ratings = @all_ratings.to_h { |rating| [rating, 1] }
    end
  end
  
  
  

  def self.with_ratings(ratings)
    where(rating: ratings)
  end
  

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end


