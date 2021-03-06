Given /^there is another user$/ do
  @other_user = Factory.create(:user)
end

Given /^there is a user$/ do
  @user = Factory.create(:user)
end

When /^I view their code profile$/ do
  visit profile_code_path(@other_user.profile)
end

When /^I view their knowledge profile$/ do
  visit profile_knowledge_path(@other_user.profile)
end

When /^I view their speaker profile$/ do
  visit profile_speaking_path(@other_user.profile)
end

When /^I view their social profile$/ do
  visit profile_social_path(@other_user.profile)
end
