class StackOverflowQuestionAddedEvent < ProfileEvent

  referenced_in :stack_overflow_question, :inverse_of => :events

  def set_info
    self.is_public = true
    self.category = "Code"
    self.date = stack_overflow_question.date 
  end

  def description
    %Q{asked "#{stack_overflow_question.title}?" on StackOverflow}
  end

end