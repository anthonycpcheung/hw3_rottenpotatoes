require 'spec_helper'

describe MoviesHelper do
  describe 'oddness' do
    it 'return odd for 1' do
      oddness(1).should == 'odd'
    end
    it 'return even for 2' do
      oddness(1).should == 'odd'
    end
  end
end
