class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    @selected_ratings = params[:ratings] || session[:ratings] || Movie.default_ratings
    @sort_by = params[:sort_by] || session[:sort_by] || :id
      
    @movies = Movie.where("rating IN (?)", @selected_ratings.keys).order(@sort_by)

    # Redirect if Params were not complete
    unless params[:ratings] && params[:sort_by] then
      flash.keep
      redirect_to movies_path({:ratings => @selected_ratings, :sort_by => @sort_by})
    end

    # Set Session Variables
    session[:ratings] = @selected_ratings
    session[:sort_by] = @sort_by

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
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

end
