#!/usr/bin/env ruby

require 'mongo'
require 'bson'

include Mongo

if ARGV.nil? || ARGV.length != 1
  abort("Usage: bundle exec image_loader.rb <PATH_TO_IMAGE>")
end 

path_to_image = ARGV[0]

host = ENV['MONGO_RUBY_DRIVER_HOST'] || 'localhost'
port = ENV['MONGO_RUBY_DRIVER_PORT'] || MongoClient::DEFAULT_PORT

puts "Connecting to #{host}:#{port}"
db = MongoClient.new(host, port).db('video_freaks_development')

coll = db.collection("thumbnails")
coll.insert({
  "url_prefix" => File.basename(path_to_image, ".*")
  "image" => BSON::Binary.new(File.read(path_to_image), BSON::Binary::SUBTYPE_BYTES)
})

db.connection.close()
