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
    need_to_redirect = false
    #sort logic
    @sort = nil
    if (params[:sort])
      @sort = params[:sort]
      session[:sort] = @sort
    elsif (session[:sort])
      @sort = session[:sort]
      need_to_redirect = true
    end
    
    @selected_ratings = {}
    @all_ratings.each do |key| 
      @selected_ratings[key] = '1' 
    end
    puts "These are selected ratings after dumb dumb", @selected_ratings
    
    if (params[:ratings])
      @selected_ratings = params[:ratings]
      session[:ratings] = @selected_ratings
    elsif (session[:ratings])
      need_to_redirect = true
      @selected_ratings = session[:ratings]
    end
    puts "These are selected ratings", @selected_ratings
    # @selected_ratings = @selected_ratings.keys
    #remember the ratings we had through variable to be used in view
    @selected_ratings.keys.each do |rating|
      params[rating] = true
    end
    

    #RESTful behavior
    if (need_to_redirect)
      puts "HELLLLLLLLLLO"
      flash.keep
      redirect_to movies_path(:sort => @sort, :ratings => @ratings)
    else
      @movies = Movie.where(:rating => @selected_ratings.keys).order(@sort)
    end
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
