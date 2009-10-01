$:.unshift File.dirname(__FILE__)

require 'core_ext/nil_class'
require 'core_ext/string'

module Sluggable
  module ClassMethods
    
    # Determine the database column to use when generating the slug
    def slug_from(column, options = {})
      define_method(:slug_source) { column }
      define_method(:slug_scope)  { Array(options[:scope]) }
    end
    
  end
  
  module InstanceMethods
    
    def next_available_slug(base_slug) # :nodoc:
      valid_slug = base_slug

      index = 2
      while self.class.find_by_slug(valid_slug, slug_conditions)
        valid_slug = base_slug + "-#{index}"
        index+= 1
      end
      valid_slug
    end
    
    def generate_slug # :nodoc:
      self.slug = next_available_slug(self.send(slug_source).sluggify)
    end
    
    def conditions_for(column, include = true)
      operator = include ? '=' : '!='
      ["#{column} #{operator} ?", self[column]] unless self[column].blank?
    end
    
    def slug_conditions
      condition_parts = [conditions_for(:id, false)]
      condition_parts += slug_scope.map {|c| conditions_for(c) }
      condition_parts.compact!
      
      condition_string     = condition_parts.map {|p| p[0] }.join(' AND ')
      condition_parameters = condition_parts.map {|p| p[1] }

      condition_parts.empty? ? {} : {:conditions => [condition_string, *condition_parameters]}
    end
    
    private :next_available_slug, :generate_slug
    
  end
  
  def self.included(other) # :nodoc:
    other.send(:extend, Sluggable::ClassMethods)
    other.send(:include, Sluggable::InstanceMethods)
  end
  
end