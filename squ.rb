require 'chatterbot/dsl'
require 'csv'
require 'json'
require 'net/http'

consumer_key 'CQsRWmKnku4gH50mPyGxRLc3a'
consumer_secret 'XyvkFN6wfavmRrTqM8FaziM0bgTkxv7okNf9ggBDCTghgpVImS'
secret 'TbIFP1cWHr6zUczg2kDhoRoFrg5mNpmuXdfRKnFGKT6TF'
token '2727339115-9kpB4zBOB9S4N9u7PiTBUk4Jfck3W93YQz7Bnd7'


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


  # https://{account}.cartodb.com/api/v2/sql?q=INSERT INTO test_table (column_name, column_name_2, the_geom) VALUES ('this is a string', 11, ST_SetSRID(ST_Point(-110, 43),4326))&api_key={Your API key}
  #
  # uri = URI.parse("https://wrfcarl.cartodb.com/api/v2/sql?q=SELECT count(*) FROM squ &api_key=4de33fff24bf12ab92ec7ca9dbf4df23342c6966")
  # puts uri

   uri = URI('https://wrfcarl.cartodb.com/api/v2/sql?q=SELECT*FROM+squ&api_key=4de33fff24bf12ab92ec7ca9dbf4df23342c6966')
  #
   response = Net::HTTP.get(uri)
   puts response

  # post_to_carto =  'https://wrfcarl.cartodb.com/api/v2/sql?q=INSERT+INTO+squ(id,lat,long,user,text,tweet_created_at)+VALUES+(#{tweet.id}, #{coordinates[0]},#{coordinates[1]},#{tweet.user.screen_name},#{tweet.text.gsub(/\n/,'')},#{tweet.created_at})&api_key=4de33fff24bf12ab92ec7ca9dbf4df23342c6966'
  # Net::HTTP.get(post_to_carto)

  end

end
