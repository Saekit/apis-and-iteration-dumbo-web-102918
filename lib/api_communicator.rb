require 'rest-client'
require 'json'
require 'pry'

def get_character_movies_from_api(character)
  #make the web request
  movies = []
  # iterate over the response hash to find the collection of `films` for the given
  get_character_info(character)["films"].each do |link|
    resp_hash = JSON.parse(RestClient.get(link))
    movies << resp_hash["title"]
    end
  movies
end

def print_movies(films_hash)
  films_hash.each_with_index do |movie, index|
    puts "#{index + 1} #{movie}"
  end
end

def show_character_movies(character)
  films_array = get_character_movies_from_api(character)
  print_movies(films_array)
end




## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?

#method that returns the response hash #done
def response_hash
  JSON.parse(RestClient.get('http://www.swapi.co/api/people/'))
end

#method that takes character name and return character's info
def get_character_info(character)
  character_info = {}
  character_info_array.each do |a_character|
    if a_character["name"].downcase == character
      character_info = a_character
    end
  end
  character_info
end

#method that takes character name and attr and returns it's data
def get_character_attr(character, attr)
  get_character_info(character)[attr] #<< accessing hash
end

#gathers character info from all pages on SWAPI into an array and returns that array
def character_info_array
  puts "\nGathering information, just a sec..."
  puts "*" * 10

  array = []
  array << response_hash["results"]
  array_of_character_info = []

resp_hash = response_hash
  while resp_hash["next"]
      new_link = resp_hash["next"]
      resp_hash = JSON.parse(RestClient.get(new_link))
      array << resp_hash["results"]
  end
  array.each do |page|
    array_of_character_info.concat(page)
  end
  array_of_character_info
end
#make an array containing all character hashes
