class TagEvent < Event
  field :taggable_id, :type => String
  field :class_name, :type => String

  scope :tag_for, lambda { |id| where(:taggable_id => id) }

  attr_accessor :taggable_object
  attr_accessor :model_name
  
  def taggable
    if @taggable_object.nil? && Kernel.const_defined?(class_name)
      @model_name = Kernel.const_get(class_name)
      @taggable_object = @model_name.find(taggable_id)
    end
    @taggable_object
  end 

  def do_work
    set_tags_from_tags_text
    set_tags if self.respond_to?(:set_tags)

    taggable.turn_off_events if taggable.respond_to? :turn_off_events
    taggable.save
    taggable.turn_on_events if taggable.respond_to? :turn_on_events

    if taggable.respond_to? :related_items
      taggable.related_items.each{|t| t.retag! unless t.nil? }
    end
  end

  def tag(tag, options={})
    options[:count] ||= 1
    options[:score] ||= 1
    
    tagging = get_tagging(tag)
    if tagging.nil?
      tagging = Tagging.new
      tagging.tag = Tag.find_or_create_named(tag) 
    end
    tagging.count += options[:count]
    tagging.score += options[:score]
    tagging.save
    taggable.taggings << tagging
  end

  def get_tagging(tag)
    t = Tag.named(tag).first
    return nil if t.nil?
    taggable.taggings.select{|tagging| tagging.tag == t}.first
  end

  def set_tags_from_tags_text
    return if taggable.tags_text.nil?

    taggable.tags_text.split(',').map{|s| s.strip}.each do |t|
      tag t
    end
  end
      
end