class Blog
  include Mongoid::Document
  
  field :title, :type => String
  field :url, :type => String
  field :rss, :type => String
  field :blog_type, :type => String
  
  embeds_many :posts
  embedded_in :profile, :inverse_of => :blog

  def sync!
    
  end
  
end