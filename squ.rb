require 'chatterbot/dsl'
require 'csv'
require 'json'
require 'net/http'

consumer_key 'xxx'
consumer_secret 'xxx'
secret 'xxx'
token 'xxx'


def center (tweet_box)

  coor = tweet_box.flatten(1)[0..2]

  newlat = (coor[0][1] + coor[2][1]) / 2
  newlong = (coor[0][0] + coor[1][0]) / 2

newcoord = [newlat, newlong]

return newcoord

end

bot = Chatterbot::Bot.new


bot.search('#squirrel') do |tweet|

  unless tweet.place.bounding_box.coordinates.nil?


  coordinates = center(tweet.place.bounding_box.coordinates)

  entry = [tweet.id, coordinates[0], coordinates[1], tweet.user.screen_name, tweet.text.gsub(/\n/,''), tweet.created_at]

  CSV.open("/Users/cro/RubymineProjects/chartbot/squ/squ.csv","a") do |file|
    file << entry
  end

   uri = URI('your_carto_db_api_key')

   response = Net::HTTP.get(uri)
   puts response

  end

end
