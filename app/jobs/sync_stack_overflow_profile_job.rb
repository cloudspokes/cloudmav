class SyncStackOverflowProfileJob
  @queue = :sync
  
  def self.perform(id)
    stack_overflow_profile = StackOverflowProfile.find(id)
    profile = stack_overflow_profile.profile
    
    if stack_overflow_profile.stack_overflow_id.nil?
      stack_overflow_profile.set_error_message! "I think you forgot to enter your id."
      return
    end
    
    user = API::StackOverflow.get_user(stack_overflow_profile.stack_overflow_id)
    
    if user.nil?
      stack_overflow_profile.set_error_message! "You couldn't find you on StackOverflow. Double check that you entered your id and not your username."
      return      
    end
    
    sync_user_data(user, stack_overflow_profile)
    sync_tags(stack_overflow_profile)
    sync_questions(stack_overflow_profile)
    sync_answers(stack_overflow_profile)

    stack_overflow_profile.profile.save!
    stack_overflow_profile.last_synced_date = DateTime.now
    stack_overflow_profile.save!

    stack_overflow_profile.retag!
    
    profile.award_badge("Stack Junkie", :description => "For having a Stackoverflow account")
    if stack_overflow_profile.reputation > 10000
      profile.award_badge("I'm kind of a Big Deal", :description => "For having a StackOverflow reputation over 10k")
    end
    
    profile.calculate_score!  
  end
  
  def self.sync_user_data(user, stack_overflow_profile)
    stack_overflow_profile.profile.name = user["display_name"] if stack_overflow_profile.profile.name.nil?
    stack_overflow_profile.url = "http://www.stackoverflow.com/users/#{stack_overflow_profile.stack_overflow_id}"
    stack_overflow_profile.reputation = user["reputation"]
    stack_overflow_profile.badge_html = user["badgeHtml"]    
  end
  
  def self.sync_tags(stack_overflow_profile)
    tags = API::StackOverflow.get_user_tags(stack_overflow_profile.stack_overflow_id)
    return if tags.nil?
    so_tags = {}
    tags["tags"].each do |t|
      so_tags[t["name"]] = t["count"]
    end
    stack_overflow_profile.stack_overflow_tags = so_tags.to_yaml
  end
  
  def self.sync_questions(stack_overflow_profile)
    questions = API::StackOverflow.get_user_questions(stack_overflow_profile.stack_overflow_id)
    return if questions.nil?

    top_questions = questions.sort{|a,b| b.vote_count <=> a.vote_count }.first(3)

    top_questions.each do |so_question|
      question = stack_overflow_profile.questions.where(:question_id => so_question.id).first
      unless question
        question = stack_overflow_profile.questions.build
      end
      question.title = so_question.title
      question.question_id = so_question.id
      question.url = "http://www.stackoverflow.com/questions/#{so_question.id}"
      question.date = so_question.creation_date
      question.score = so_question.score
      question.vote_count = so_question.vote_count
      question.view_count = so_question.view_count
      question.save
    end

    top_question_ids = top_questions.map{|q| q.id }
    questions_to_delete = stack_overflow_profile.questions.not_in(:question_id => top_question_ids)
    questions_to_delete.each{|q| q.destroy }
  end
  
  def self.sync_answers(stack_overflow_profile)
    answers = API::StackOverflow.get_user_answers(stack_overflow_profile.stack_overflow_id)
    return if answers.nil?

    top_answers = answers.sort{|a,b| b.vote_count <=> a.vote_count }.first(3)

    top_answers.each do |so_answer|
      answer = stack_overflow_profile.answers.where(:answer_id => so_answer.id).first
      unless answer
        answer = stack_overflow_profile.answers.build
      end
      answer.title = so_answer.title
      answer.question_id = so_answer.question_id
      answer.answer_id = so_answer.id
      answer.accepted = so_answer.accepted
      answer.url = "http://www.stackoverflow.com/questions/#{so_answer.question_id}"
      answer.date = so_answer.creation_date
      answer.score = so_answer.score
      answer.vote_count = so_answer.vote_count
      answer.view_count = so_answer.view_count
      answer.save
    end

    top_answer_ids = top_answers.map{|a| a.id }
    answers_to_delete = stack_overflow_profile.answers.not_in(:answer_id => top_answer_ids)
    answers_to_delete.each{|a| a.destroy }
  end
  
  def self.convert_to_date(value)
    if (value.class == String)
      value = value.sub(" ","").to_i
    end
    Time.at(value)
  end
end