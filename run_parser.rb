require './parser.rb'

parser = LogParser.new('games.log')

def games_summarize(parser)
  parser.parse_games().each_with_index.map{|game,index| {"game_#{index}" => game.game_summarize}}
end

def get_ranking(parser)
  players_score = parser.parse_games().flat_map do |game|
    game.get_players_score().map { |player| player.match(/(?<player>[^:]+): (?<points>[^.]+)/) }
  end
  ranking = parser.parse_players().map do |player| 
    players_score.select {|score| score[:player] == player.name}
                 .each { |score| player.points += score[:points].to_i }
    player
  end
  ranking.sort_by {|player| -player.points}
end

result = {
  :games => games_summarize(parser),
  :ranking => get_ranking(parser)
}

puts result






