require './player.rb'
class Game 
  attr_accessor :logs

  def initialize(logs)
    @logs = logs
  end

  def get_kills
    logs.map do |line| 
      match = line.match(/: (?<killer>[^:]+) killed (?<killed>.+) by/) 
      match ? match.named_captures : nil 
    end.compact
  end

  def get_players
    players_name_list = get_kills().flat_map {|kill| kill.values}.select {|player_name| player_name != "<world>"}.uniq
    players_name_list.map {|player_name| Player.new(player_name)}
  end

  def get_players_score
    players = get_players()
    players_score =  players.map do |player| 
      get_kills().each do |kill|
        player.points += 1 if (player.name == kill["killer"] && player.name != kill["killed"])
        player.points -= 1 if (player.name == kill["killer"] && player.name == kill["killed"] || kill["killer"] == "<world>" && player.name == kill["killed"])
      end 
      player.to_s
    end
  end

  def game_summarize
    total_kills = get_kills().count
    players = get_players().map {|player| player.name}
    players_score = get_players_score()
    result = {:total_kills =>total_kills , :players => players, :kills => players_score}
  end
end