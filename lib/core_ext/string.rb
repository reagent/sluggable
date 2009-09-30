class String
  
  # Generate the slug version for this string
  def sluggify
    slug = self.downcase.gsub(/[^0-9a-z_ -]/i, '')
    slug = slug.gsub(/\s+/, '-').squeeze('-')
    slug
  end
end