module CodeMav
  module ExperienceModule
    def self.included(receiver)
      receiver.class_eval do
        references_many :jobs, :inverse_of => :profile
        references_one :experience_profile, :inverse_of => :profile

        before_create :create_experience_profile
      end
      
      receiver.send(:include, InstanceMethods)
    end
    
    module InstanceMethods

      def create_experience_profile
        self.experience_profile = ExperienceProfile.new 
      end
      
      def calculate_experience_tags
        self.jobs.each do |job|
          job.tags.each {|t| self.tag! t }
        end
      end
      
      def experience_tags
        self.projects.map{|p| p.technologies }.flatten.map{|t| t.name}
      end
      
      def calculate_experience
        self.experiences.each{|e| e.destroy}
        self.projects.each do |project|
          project_xp = project.get_xp
          project_xp.each_pair do |name, duration|
            xp = find_create_xp(name)
            unless duration.nil?
              sum = xp.duration + duration
              xp.duration= sum.to_i
            end
          end
        end
      end
      
      def experience_with(technology_name)
        self.experiences.with(technology_name).first
      end
      
      def has_job?(title)
        self.jobs.where(:title => title).first
      end
      
      private
        def find_create_xp(name)
          xp = self.experiences.with(name).first
          unless xp
            xp = Experience.new
            xp.name = name
            xp.technology = Technology.named(name).first
            xp.duration = 0
            self.experiences << xp
          end
          return xp
        end
    end
  end
end