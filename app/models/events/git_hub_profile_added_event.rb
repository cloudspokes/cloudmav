class GitHubProfileAddedEvent < ProfileEvent

  referenced_in :git_hub_profile, :inverse_of => :events

  def award_badges
    profile.award_badge("Git R Done", :description => "For having a GitHub account")
  end

  def score_points
    profile.earn("for adding GitHub", 10, :coder_points) 
  end

  def set_info
    self.is_public = true
    self.category = "Code"
    self.subcategory = "GitHub"
  end

  def description
    %Q{added GitHub to CodeMav}
  end

  def icon_url
    "event_icons/github.png"
  end

end