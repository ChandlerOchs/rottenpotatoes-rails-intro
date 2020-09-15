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
    @sort = params[:sort] || session[:sort]
    @selected_ratings = params[:ratings] || session[:ratings]
    if (!@selected_ratings)
        @selected_ratings = {}
        @all_ratings.each do |val| 
          @selected_ratings[val] = '1' 
        end
    end
    # @selected_ratings = @selected_ratings.keys
    #remember the ratings we had through variable to be used in view
    @selected_ratings.keys.each do |rating|
      params[rating] = true
    end
    @movies = Movie.where(:rating => @selected_ratings.keys).order(@sort)
    # else
    #   puts "you came here"
    #   @selected_ratings = @all_ratings
    #   @selected_ratings.each do |rating|
    #     params[rating] = true
    #   end
    #   if (@sort.eql?("titles"))
    #     @movies = Movie.order(:title)
    #   elsif (@sort.eql?("dates"))
    #     @movies = Movie.order(:release_date)
    #   else
    #     @movies = Movie.all
    #   end
    # end
    session[:sort] = @sort
    session[:ratings] = @ratings
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      flash.keep
      redirect_to movies_path sort: @sort, ratings: @ratings
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
