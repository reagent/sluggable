require File.dirname(__FILE__) + '/../test_helper'

class Blog < ActiveRecord::Base

  include Sluggable
  slug_from :name

end

class Post < ActiveRecord::Base

  include Sluggable
  slug_from :title, :scope => :blog_id

end

class SluggableImplementationTest < Test::Unit::TestCase

  context "An instance of the Blog class" do
    teardown { Blog.destroy_all }

    should "know the column to use when generating the slug" do
      Blog.new.slug_source.should == :name
    end

    should "know the scope for finding the uniqueness of the slug" do
      Blog.new.slug_scope.should == []
    end

    should "know how to generate the conditions for a column when it exists" do
      blog = Blog.create!(:name => 'Mine')
      blog.conditions_for(:id).should == ['id = ?', blog.id]
    end
    
    should "know how to generate the conditions for a column when it should not be included" do
      blog = Blog.create!(:name => 'Mine')
      blog.conditions_for(:id, false).should == ['id != ?', blog.id]
    end

    should "know how to generate the conditions for a column when it doesn't exist" do
      blog = Blog.new
      blog.conditions_for(:id).should be_nil
    end

    should "generate an empty set of conditions when there is no id" do
      blog = Blog.new
      blog.slug_conditions.should == {}
    end

    should "generate a set of conditions when there is an ID" do
      blog = Blog.create!(:name => 'Me')
      blog.slug_conditions.should == {:conditions => ['id != ?', blog.id]}
    end

    should "know the next available slug when the original is taken" do
      Blog.create!(:name => 'One', :slug => 'one')

      blog = Blog.new
      blog.send(:next_available_slug, 'one').should == 'one-2'
    end

    should "incrementally suggest slugs until it finds an available one" do
      Blog.create!(:name => 'One', :slug => 'one')
      Blog.create!(:name => 'One', :slug => 'one-2')

      blog = Blog.new

      blog.send(:next_available_slug, 'one').should == 'one-3'
    end

    should "know not to suggest an incremental slug when the existing slug belongs to the current record" do
      blog = Blog.create!(:name => 'One', :slug => 'one')
      blog.send(:next_available_slug, 'one').should == 'one'
    end

    should "be able to assign a valid slug to the slug property" do
      blog = Blog.new(:name => 'One')
      blog.send(:generate_slug)
      
      blog.slug.should == 'one'
    end

  end

  context "An instance of the Post class" do
    teardown do
      Post.destroy_all
      Blog.destroy_all
    end
  
    should "know the scope for finding the uniqueness of the slug" do
      Post.new.slug_scope.should == [:blog_id]
    end
  
    should "be able to generate a set of conditions when there is no ID" do
      p = Post.new(:blog_id => 1)
      p.slug_conditions.should == {:conditions => ['blog_id = ?', 1]}
    end
  
    should "be able to generate a set of conditions when there is an ID" do
      p = Post.create!(:title => 'Title', :body => 'Text', :blog_id => 1)
      p.slug_conditions.should == {:conditions => ['id != ? AND blog_id = ?', p.id, 1]}
    end
    
    should "maintain the current slug when one exists scoped to another blog_id" do
      Post.create!(:title => 'Title', :body => 'Text', :blog_id => 1, :slug => 'title')
      p = Post.new(:title => 'Title', :body => 'Text', :blog_id => 2)
      
      p.send(:generate_slug)
      
      p.slug.should == 'title'
    end
    
    should "increment the slug when one exists scoped to the same blog" do
      Post.create!(:title => 'Title', :body => 'Text', :blog_id => 1, :slug => 'title')
      p = Post.new(:title => 'Title', :body => 'Text', :blog_id => 1)

      p.send(:generate_slug)
      
      p.slug.should == 'title-2'
    end
    
  end


end



