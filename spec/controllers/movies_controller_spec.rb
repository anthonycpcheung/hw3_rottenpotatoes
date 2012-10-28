require 'spec_helper'

describe MoviesController do
  describe 'index' do
    it 'should show all rating by default' do
      all_ratings = %w(G PG PG-13 NC-17 R)
      Movie.should_receive(:find_all_by_rating).with(all_ratings, nil)
      get :index      
    end
    it 'should sort title' do
      all_ratings = Hash[%w(G PG PG-13 NC-17 R).map {|rating| [rating, rating]}]
      get :index, {:sort => 'title'}
      response.should redirect_to(movies_path(:ratings=>all_ratings, :sort=>'title'))
    end
    it 'should sort release_date' do
      all_ratings = Hash[%w(G PG PG-13 NC-17 R).map {|rating| [rating, rating]}]
      get :index, {:sort => 'release_date'}
      response.should redirect_to(movies_path(:ratings=>all_ratings, :sort=>'release_date'))
    end
  end

  describe 'new' do
    it 'should render show template' do
      get :new
      response.should render_template('new')
    end
  end

  describe 'create' do
    it 'should create a movie' do
      fake_params = {:movie => {'title' => 'title', 'rating' => 'P', 'director' => 'director', 'release_date' => '1980-01-01'}}
      fake_movie = mock_model(Movie, :title => 'title')
      Movie.should_receive(:create!).with(fake_params[:movie]).and_return(fake_movie)
      post :create, fake_params
    end
    it 'should redirect to home page' do
      fake_params = {:movie => {:title => 'title', :rating => 'P', :director => 'director', :release_date => '1980-01-01'}}
      fake_movie = mock_model(Movie, :title => 'title')
      Movie.stub(:create!).and_return(fake_movie)
      post :create, fake_params
      response.should redirect_to(movies_path)
    end
  end

  describe 'edit' do
    it 'should show edit page' do
      fake_movie = mock_model(Movie)
      Movie.stub(:find).and_return(fake_movie)
      get :edit, {:id=>fake_movie.id}
      response.should render_template('edit')
    end
  end

  describe 'show' do
    it 'should render show template' do
      fake_movie = mock_model(Movie)
      Movie.stub(:find).and_return(fake_movie)
      get :show, {:id => 1}
      assigns[:movie].should eq(fake_movie)
      response.should render_template('show')
    end
  end

  describe 'update' do
    it 'should call update' do
      @fake_movie = mock_model(Movie, :title => 'title')
      Movie.stub(:find).and_return(@fake_movie)
      @fake_movie.should_receive(:update_attributes!)
      post :update, {:id => 1, :title => 'title0', :rating => 'PG', :director => 'director0', :release_date => '1980-01-02'}
    end
    it 'should redirect to details page' do
      @fake_movie = mock_model(Movie, :title => 'title')
      Movie.stub(:find).and_return(@fake_movie)
      @fake_movie.stub(:update_attributes!)
      post :update, {:id => @fake_movie.id, :title => 'title0', :rating => 'PG', :director => 'director0', :release_date => '1980-01-02'}
      response.should redirect_to(movie_path)
    end
  end

  describe 'destroy' do
    it 'should call destroy' do
      @fake_movie = mock_model(Movie, :title => 'title')
      Movie.stub(:find).and_return(@fake_movie)
      @fake_movie.should_receive(:destroy)
      post :destroy, {:id => @fake_movie.id}
    end
    it 'should redirect to home page' do
      @fake_movie = mock_model(Movie, :title => 'title')
      Movie.stub(:find).and_return(@fake_movie)
      @fake_movie.stub(:destroy)
      post :destroy, {:id => @fake_movie.id}
      response.should redirect_to(movies_path)
    end
  end

  describe 'similar_movies' do
    it 'should search model using received director' do
      fake_movie = mock_model(Movie, :director=>'George Lucas')
      Movie.stub(:find).and_return(fake_movie)
      Movie.should_receive(:where).with('director'=>'George Lucas')
      get :similar_movies, :id => 1
    end
    it 'should select the Find Similar template for rendering' do
      fake_movie = mock_model(Movie, :director=>'George Lucas')
      Movie.stub(:find).and_return(fake_movie)
      Movie.stub(:where)
      get :similar_movies, {:id => 1}
      response.should render_template('similar_movie')
    end
    it 'should pass the search results to Find Similar template' do
      fake_movie = mock_model(Movie, :director=>'George Lucas')
      Movie.stub(:find).and_return(fake_movie)
      fake_results = [mock('Movie'), mock('Movie')]
      Movie.stub(:where).and_return(fake_results)
      get :similar_movies, {:id => 1}
      assigns(:movies).should == fake_results
    end
    it 'should redirect to home page for movie has no director' do
      fake_movie = mock_model(Movie, :title=>'Alien', :director=>nil)
      Movie.stub(:find).and_return(fake_movie)
      get :similar_movies, {:id => 1}
      response.should redirect_to('/movies')
    end
  end
end
