When /^I sync my Twitter account$/ do
  VCR.use_cassette("twitter", :record => :new_episodes) do
    visit new_profile_twitter_profile_path(@profile)
    fill_in "twitter_profile_username", :with => 'rookieone'
    click_button "Save"
  end
end

Then /^I should have a Twitter profile$/ do
  profile = User.find(@user.id).profile
  profile.twitter_profile.should_not be_nil
end

Then /^I should have followers on twitter$/ do
  profile = User.find(@user.id).profile
  profile.twitter_profile.followers_count.should_not == 0
end

Then /^it should pull my name from twitter$/ do
  profile = User.find(@user.id).profile
  profile.name.should_not be_nil
end

Then /^it should pull my location from twitter$/ do
  profile = User.find(@user.id).profile
  profile.location.should_not be_nil
end

Given /^I have a Twitter profile$/ do
  @twitter_profile = Factory.create(:twitter_profile, :profile => @profile)
end

When /^I edit my Twitter profile$/ do
  VCR.use_cassette("twitter_update", :record => :new_episodes) do
    visit edit_profile_twitter_profile_path(@profile, @twitter_profile)
    fill_in "twitter_profile_username", :with => "rookieone"
    click_button "Save"
  end
end

Then /^my Twitter profile should be updated$/ do
  @twitter_profile.reload
  @twitter_profile.username.should == "rookieone"
end

When /^I view their social profile$/ do
  visit profile_social_path(@other_user.profile)
end

Then /^I should not see their Twitter profile$/ do
  And %Q{I should not see "Go to my Twitter page"}
end

Given /^the other user has a Twitter profile$/ do
  VCR.use_cassette("other twitter", :record => :new_episodes) do
    Factory.create(:twitter_profile, :username => "rookieone", :profile => @other_user.profile)
    @other_user.profile.save
  end
end

Then /^I should see their Twitter profile$/ do
  And %Q{I should see "Go to my Twitter page"}
end

