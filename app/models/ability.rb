class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?
    return if user.profile.nil?
    
    can :tweet, Profile do |profile|
      user.profile == profile
    end
    can :sync_profile, Profile do |profile|
      user.profile == profile
    end
    can [:add_talk], Profile do |profile|
      user.profile == profile
    end
    can [:follow], Profile do |profile|
      user.profile != profile
    end
    can [:edit, :delete, :add_post], Blog do |blog|
      user.profile == blog.profile
    end
    if user.profile.moderator?
      can [:edit], Company
    end
  end
end
