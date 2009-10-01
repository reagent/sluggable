# http://sneaq.net/textmate-wtf
$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'throat_punch'

require 'activerecord'

require File.dirname(__FILE__) + '/../lib/sluggable'

path = File.dirname(__FILE__) + '/support'
require "#{path}/configuration"

ActiveRecord::Base.establish_connection(Configuration.database(path))

