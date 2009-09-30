require File.dirname(__FILE__) + '/../../test_helper'

class StringTest < Test::Unit::TestCase
  
  context "An instance of String" do
    context "when creating a slug" do
      
      should "remove non-word characters" do
        assert_equal 'postname', '!#pos$%t+name'.sluggify
      end
      
      should "transform a space into a dash" do
        assert_equal 'post-name', 'post name'.sluggify
      end
      
      should "transform multiple spaces into a single dash" do
        assert_equal 'post-name', "post   name".sluggify
      end
      
      should "downcase the original string when creating the slug" do
        assert_equal 'postname', 'PostName'.sluggify
      end
      
      should "consolidate multiple dashes in the output" do
        assert_equal 'post-name', 'post- name'.sluggify
      end
      
    end
  end
  
end