class StackOverflowAnswer
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :stack_overflow_profile, :inverse_of => :answers

  field :title, :type => String
  field :question_id, :type => String
  field :answer_id, :type => String
  field :url, :type => String
  field :date, :type => DateTime
  field :accepted, :type => Boolean
  field :score, :type => String
  field :vote_count, :type => String
  field :view_count, :type => String

  def accepted?
    accepted
  end

  def profile
    stack_overflow_profile.profile
  end

end