class MoviesController < ApplicationController
  @@DefaultRatings = {'G' => '1','PG' => '1','PG-13' => 1,'R' => '1','NC-17' => '1'}		
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

	@all_ratings = Movie.find_ratings

	if session[:sort] != params[:sort] and params[:sort]
      session[:sort] = params[:sort]
    end

    if session[:ratings] != params[:ratings] and params[:ratings]
      session[:ratings] = params[:ratings]
    end

    if !params[:sort] && !params[:ratings] && (session[:sort] || session[:ratings])
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end

	if session[:ratings]
	  @selected_ratings = session[:ratings].keys
    else
      @selected_ratings = @all_ratings
    end

	if session[:sort] 
		@movies = Movie.sort_by(session[:sort],@selected_ratings)
	else
		@movies = Movie.find_all_by_rating(@selected_ratings)
	end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
