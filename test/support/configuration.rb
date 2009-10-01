class Configuration
  
  def self.database(path)
    {:adapter => 'sqlite3', :database => "#{path}/test.sqlite3", :timeout => 5000}
  end
  
end