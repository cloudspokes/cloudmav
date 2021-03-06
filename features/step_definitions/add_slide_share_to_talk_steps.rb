When /^I try to link my talk to SlideShare$/ do
  visit new_profile_talk_link_to_slide_share_path(@profile, @talk)
end

Then /^I should be able to add my talk to SlideShare$/ do
  And %Q{I should see "Add slides to SlideShare"}
end

Given /^I have a talk from SlideShare$/ do
  @slide_share_talk = Factory.create(:talk, :profile => @profile)
  @slide_share_talk.has_slide_share = true
  @slide_share_talk.slide_share_id = "100"
  @slide_share_talk.slideshow_html = "Test"
  @slide_share_talk.save
end

When /^I link the talk to the SlideShare talk$/ do
  visit new_profile_talk_link_to_slide_share_path(@profile, @talk)
  click_button "Link"
end

Then /^the talk should have my SlideShare info$/ do
  @talk.reload
  @talk.slide_share_id.should == "100"
  @talk.slideshow_html.should == "Test"
end

Then /^my SlideShare talk should be deleted$/ do
  Talk.where(:id => @slide_share_talk.id).first.should == nil
end

Given /^I added a talk to SlideShare$/ do
end

When /^I refresh from the link my talk to SlideShare$/ do
  @slide_share_profile = SlideShareProfile.new(:profile => @profile, :slide_share_username => "rookieone")
  @slide_share_profile.stubs(:sync!)
  @slide_share_profile.save

  visit new_profile_talk_link_to_slide_share_path(@profile, @talk)
  VCR.use_cassette('refresh_link_to_slide_share', :record => :new_episodes) do
    click_link "Sync with SlideShare"
  end
end

Then /^I should be able to select the SlideShare talk$/ do
  page.has_content?("Evolve Your Code").should == true
end
