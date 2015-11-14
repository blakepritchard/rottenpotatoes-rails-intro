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
    puts "Params: Order= #{params[:order_by]} , Ratings= #{params.has_key?(:ratings) && params[:ratings]}"
    
    @all_ratings = Movie.all_ratings
    
    # Use session variables
    if params.has_key?(:ratings) then
      if params[:ratings].is_a?(Hash) then
        @selected_ratings = params[:ratings].keys
      else  
        @selected_ratings = params[:ratings]
      end
      puts "using params= #{params}"
    elsif session[:ratings]
      @selected_ratings = session[:ratings]
      puts "using session"
    else
      @selected_ratings = @all_ratings
      puts "using defaults: #{@selected_ratings}"
    end
    
    
    @order_by = params[:order_by] || session[:order_by] || :id
      
    puts "Runtime: Order= #{@order_by}, Ratings= #{@selected_ratings}"  
    @movies = Movie.where("rating IN (?)", @selected_ratings).order(@order_by)

    # Redirect if Params were not complete
    unless params[:ratings] && params[:order_by] then
      puts "Redirecting"
      flash.keep
      redirect_to movies_path({:ratings => @selected_ratings, :order_by => @order_by})
    end

    # Set Session Variables
    session[:ratings] = @selected_ratings
    session[:order_by] = @order_by

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
