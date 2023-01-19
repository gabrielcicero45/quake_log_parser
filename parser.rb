require './game.rb'
class LogParser
  attr_reader :logs

  def initialize(path)
      @logs = File.foreach(path)
  end

  def get_kills(logs)
    kills_lines = logs.select do |line| 
      line.include?("Kill:")
    end
    kills_lines.map {|line| line.match(/: (?<killer>[^:]+) killed (?<killed>.+) by/).named_captures}
  end

  def parse_games
    logs.slice_after(/InitGame/).map {|game_log| Game.new(get_kills(game_log))}
  end

  def parse_players
    players = get_kills(@logs).flat_map {|kill| kill.values}.select {|player_name| player_name != "<world>"}.uniq
    players.map {|player| Player.new(player)}
  end

  def games_summarize
    parse_games().each_with_index.map{|game,index| {"game_#{index}" => game.game_summarize}}
  end
  
  def get_ranking
    players_score = parse_games().flat_map do |game|
      game.get_players_score().map { |player| player.match(/(?<player>[^:]+): (?<points>[^.]+)/) }
    end
    ranking = parse_players().map do |player| 
      player_results = players_score.select {|a| a[:player] == player.name}
      player_results.each { |score| player.points += score[:points].to_i }
      player
    end
    ranking.sort_by {|player| -player.points}
  end
end

