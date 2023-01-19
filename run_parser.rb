require './parser.rb'

parser = LogParser.new('games.log')

result = {
  :games => parser.games_summarize(),
  :ranking => parser.get_ranking()
}

puts result




