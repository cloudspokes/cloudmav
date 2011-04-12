module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /the registration page/
      new_user_registration_path
    when /my profile page/
      profile_path(@user.profile)
    when /the people search page/
      new_people_search_path
    when /the StackOverflow scoreboard page/
      stack_overflow_scoreboards_path
      
    when /the add a company page/
      new_company_path
    when /the company "(.*)" page/
      company_path(Company.where(:name => $1).first)

    # User Groups
    when /the add a user group page/
      new_user_group_path
    when /the "(.*)" user group page/
      user_group_path(UserGroup.where(:name => $1).first)
      


    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
