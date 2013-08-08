# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  page.body.index(e1).should be <= page.body.index(e2)
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.strip.split(/\s*,\s*/).each do |rating|
    if uncheck
      uncheck('ratings_'+rating)
    else
      check('ratings_'+rating)
    end
  end
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

Then /I should see all of the movies/ do
  dbCount = Movie.find(:all).count()
  pageCount = page.all('table#movies tbody tr').count()
  dbCount.should == pageCount
end

Then /I should (not )?see the following movies: (.*)/ do |excluded, movie_list|
  movie_list.strip.split(/,/x).each do |movie|
    if excluded and page.body.include?(movie)
      raise "error"
    elsif (not excluded) and (not page.body.include?(movie))
      raise "error"
    end
  end
end