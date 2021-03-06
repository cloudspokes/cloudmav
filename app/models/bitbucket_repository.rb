class BitbucketRepository 
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :url, :type => String
  field :description, :type => String
  field :followers_count, :type => Integer 

  belongs_to :bitbucket_profile, :inverse_of => :repositories
  has_many :talks
  
  def profile
    self.bitbucket_profile.profile
  end

end

