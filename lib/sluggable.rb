$:.unshift File.dirname(__FILE__)

require 'core_ext/nil_class'
require 'core_ext/string'

module Sluggable
  module ClassMethods
    
    # Find all the other slugs in the database that don't belong to the 
    # record specified by the +:id+ parameter.
    def others_by_slug(id, slug)
      conditions = id.nil? ? {} : {:conditions => ['id != ?', id]}
      find_by_slug(slug, conditions)
    end
    
    # Determine the database column to use when generating the slug
    def slug_column(column)
      define_method(:slug_column) do
        column
      end
    end
    
  end
  
  module InstanceMethods
    
    def next_available_slug(base_slug) # :nodoc:
      valid_slug = base_slug

      index = 2
      while self.class.others_by_slug(self.id, valid_slug)
        valid_slug = base_slug + "-#{index}"
        index+= 1
      end
      valid_slug
    end
    
    def generate_slug # :nodoc:
      self.slug = next_available_slug(self.send(slug_column).sluggify)
    end
    
    private :next_available_slug, :generate_slug
    
  end
  
  def self.included(other) # :nodoc:
    other.send(:extend, Sluggable::ClassMethods)
    other.send(:include, Sluggable::InstanceMethods)
  end
  
end