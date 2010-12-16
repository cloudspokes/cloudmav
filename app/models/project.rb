class Project
  include Mongoid::Document
  
  field :name, :type => String
  field :start_date, :type => DateTime
  field :end_date, :type => DateTime
  field :technologies, :type => Array
  
  embedded_in :profile, :inverse_of => :project
  references_many :technologies, :stored_as => :array
  
  def set_technologies!(technologies_string)
    self.technologies = []
    technology_names = technologies_string.split(',').map{|s| s.strip.camelize }

    technology_names.each do |name|
      technology = Technology.named(name).first
      unless technology
        technology = Technology.create(:name => name)
      end
      self.technologies << technology
    end
  end
  
  def get_xp
    return {} if self.start_date.nil? or self.end_date.nil?
    
    starts = Time.parse(self.start_date.to_s)
    ends = Time.parse(self.end_date.to_s) 
    duration = Duration.new(:seconds => ends - starts)
    xp = {}
    technologies.each{ |t| xp[t.name] = duration }
    return xp
  end
end