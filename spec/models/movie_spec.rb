require 'spec_helper'

describe Movie do
  describe 'all_ratings' do
    Movie.all_ratings.should == %w(G PG PG-13 NC-17 R)
  end
end
