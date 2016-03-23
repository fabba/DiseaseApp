
require "rexml/document"
include REXML    # so that we don't have to prefix everything
                 # with REXML::...
doc = Document.new File.new("db/countries.xml")

doc.elements.each("countries/country") do |element|
  Country.create(code: element.attributes['code'],
                name: element.text)
	
end



# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
