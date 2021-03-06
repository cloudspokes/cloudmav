When /^my profile's skills are calculated$/ do
  @profile.calculate_skills!
end

Given /^there is a skill "([^"]*)" for tags "([^"]*)"$/ do |skill_name, tags|
  t = tags.split(",").map{|x| x.strip}
  Factory.create(:skill, :name => skill_name, :tags => t)
end

Given /^I have a talk worth (\d+) speaker points tagged with "([^"]*)"$/ do |points, tags|
  @talk = Factory.create(:talk, :profile => @profile)
  @talk.earn(points, :speaker_points, "for being awesome", @talk)
  @profile.earn(points, :speaker_points, "for Talk", @talk)  
  @talk.tags_text = tags
  @talk.save
  @talk.retag!
end

Then /^my talk should have (\d+) "([^"]*)" speaker points$/ do |points, skill_name|
  @talk.reload
  @talk.skill_score_for_type(skill_name, :speaker).should == points.to_i
end

Then /^my talk should have (\d+) "([^"]*)" points$/ do |points, skill_name|
  @talk.reload
  @talk.skill_score(skill_name).should == points.to_i
end

Then /^I should have (\d+) "([^"]*)" skill points$/ do |points, skill_name|
  @profile.reload
  @profile.skill_score(skill_name).should == points.to_i  
end

Given /^I have a GitHub repo worth (\d+) coder points tagged with "([^"]*)"$/ do |points, tags|
  @git_hub_profile = Factory.create(:git_hub_profile, :profile => @profile)
  @git_hub_repository = GitHubRepository.new
  @git_hub_repository.tags_text = tags
  @git_hub_repository.git_hub_profile = @git_hub_profile
  @git_hub_repository.save
  @git_hub_repository.retag!
  
  @git_hub_repository.earn(points, :coder_points, "for Repo", @git_hub_repository)
  @profile.earn(points, :coder_points, "for Repo", @git_hub_repository)
  
  @git_hub_profile.reload
end

Then /^my GitHub repo should have (\d+) "([^"]*)" coder points$/ do |points, skill_name|
  @git_hub_repository.reload
  @git_hub_repository.skill_score_for_type(skill_name, :coder).should == points.to_i
end

Given /^I have a job worth (\d+) experience points tagged with "([^"]*)"$/ do |points, tags|
  @job = Factory.create(:job, :profile => @profile)
  @job.tags_text = tags
  @job.save
  @job.retag!

  @job.earn(points, :experience_points, "for Job", @job)
  @profile.earn(points, :experience_points, "for Job", @job)

  @job.reload
end

Then /^my job should have (\d+) "([^"]*)" experience points$/ do |points, skill_name|
  @job.reload
  @job.skill_score_for_type(skill_name, :experience).should == points.to_i
end
