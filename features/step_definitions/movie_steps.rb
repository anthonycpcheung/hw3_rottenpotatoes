# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  pos_1 = (/#{e1}/ =~ page.body)
  pos_2 = (/#{e2}/ =~ page.body)
  assert (pos_1 < pos_2), "#{e1}(#{pos_1}) is not before #{e2}(#{pos_2})"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(/,\s*/).each do |rating|
    if uncheck
      step %Q{I uncheck "ratings[#{rating}]"}
    else
      step %{I check "ratings[#{rating}]"}
    end
  end
end

Then /^I should see all movies with following ratings: (.*)$/ do |rating_list|
  rating_list.split(/,\s*/).each do |rating|
    value = Movie.find_all_by_rating([rating]).count
    rows = page.all('tbody tr td', :text => /^#{Regexp.quote(rating)}$/).length
    assert_equal value, rows
  end
end

Then /^I should not see any movies with following ratings: (.*)$/ do |rating_list|
  rating_list.split(/,\s*/).each do |rating|
    rows = page.all('tbody tr td', :text => /^#{Regexp.quote(rating)}$/).length
    assert_equal 0, rows
  end
end

Then /^I should see all of the movies$/ do 
  step "I should see all movies with following ratings: #{Movie.all_ratings.join(",")}"
end

When /^I (un)?check all ratings$/ do |uncheck|
  Movie.all_ratings.each do |rating|
    if uncheck
      step %{I uncheck "ratings[#{rating}]"}
    else
      step %{I check "ratings[#{rating}]"}
    end
  end
end

Then /^the (.*) of "([^"]*)" should be "([^"]*)"$/ do |field, movie_title, expected_value|
  step %{I should see "#{movie_title}"}
  assert_match Regexp.new("#{field}.*[\\s\\n]+#{expected_value}",true), page.body, "#{field} is not #{expected_value}"
end
