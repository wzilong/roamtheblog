class Post < Mongomatic::Base
  
  ##
  # :title, :author, :body, :date, :updated, :slug

  ##
  # Indexes
  def self.create_indexes
    collection.create_index([[:slug,1],[:date,-1]], :unique => true)
  end
  
  ##
  # Finders
  def self.slug(slug)
    find_one(:slug => slug)
  end

  def self.nodate
    find(:date => nil).sort([:updated, :desc])
  end
  
  def self.active
    find(:date => {'$lte' => Time.now.utc}).sort([:date, :desc])
  end
  
  def self.future
    find(:date => {'$gt' => Time.now.utc}).sort([:date, :desc])
  end
  
  def self.recent(limit=nil)
    criteria = active.sort([:updated, :desc])
    criteria.limit(limit) if limit
    criteria
  end
  
  ##
  # Validations
  def validate
    self.errors.add("title","required")  if self['title'].empty?
    self.errors.add("author","required") if self['author'].empty?
    self.errors.add("body","required")   if self['body'].empty?
  end

  ##
  # Callbacks
  def before_validate
    parse_date
    generate_slug
  end
  
  def before_insert_or_update
    self['updated'] = Time.now.utc
  end
  
  def html
    RedCloth.new(self['body']).to_html
  end
  
  def excerpt
    HTML_Truncator.truncate(html, 15)
  end
  
  def active?
    self['date'] ? (Time.now.utc >= self['date']) : false
  end

  protected
  
  def parse_date
    if self['date'].is_a?(String) && _date = Chronic.parse(self['date'])
      self['date'] = _date.utc
    end
  end
  
  def generate_slug
    return false if self['title'].empty?
    prefix = if self['date'].is_a?(Time)
      self['date'].strftime("%Y%m%d")
    else
      Time.now.in_time_zone.strftime("%Y%m%d")
    end
    self['slug'] = "#{prefix}-#{self['title'].slugize}"
  end
  
end