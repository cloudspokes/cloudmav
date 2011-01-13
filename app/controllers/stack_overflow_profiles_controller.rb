class StackOverflowProfilesController < ApplicationController
  
  def new
    @stack_overflow_profile = StackOverflowProfile.new
  end
  
  def create
    @stack_overflow_profile = StackOverflowProfile.new(params[:stack_overflow_profile])
    @stack_overflow_profile.profile = current_profile
    @stack_overflow_profile.synch!
        
    redirect_to [:my, current_profile]
  end
  
end