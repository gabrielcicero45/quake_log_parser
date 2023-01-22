require './player.rb'
class Game 
  attr_accessor :kills,:means_of_death

  def initialize(kills,means_of_death)
    @kills = kills
    @means_of_death = means_of_death
  end

  def get_players
    players_name_list = kills.flat_map {|kill| kill.values}.select {|player_name| player_name != "<world>"}.uniq
    players_name_list.map {|player_name| Player.new(player_name)}
  end

  def suicide?(player_name,kill)
    (player_name == kill["killer"] && player_name == kill["killed"]) || (kill["killer"] == "<world>" && player_name == kill["killed"])
  end

  def get_players_score
    players = get_players()
    players_score =  players.map do |player| 
      kills.each do |kill|
        player.add_point  unless suicide?(player.name,kill)
        player.remove_point if suicide?(player.name,kill) 
      end 
      player.to_s
    end
  end

  def get_means_of_death
    kills_by_means = Hash.new(0)
    means_of_death.flat_map{ |mean| mean.values}.each { |mean| kills_by_means[mean] += 1 }
    kills_by_means.sort_by {|key, value| -value}.to_h
  end

  def game_summarize
    total_kills = kills.count
    players = get_players().map {|player| player.name}
    players_score = get_players_score()
    means_of_death = get_means_of_death()
    result = {:total_kills => total_kills , :players => players, :kills => players_score, :means_of_death => means_of_death }
  end
end