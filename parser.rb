require './game.rb'
class LogParser
  attr_reader :logs

  def initialize(path)
      @logs = File.foreach(path)
  end

  def get_kills(logs)
    kills_lines = logs.flat_map do |line| 
      match_line = line.match(/: (?<killer>[^:]+) killed (?<killed>.+) by/) 
      match_line.nil? ? [] : match_line.named_captures
    end
  end

  def get_means_of_death(logs)
    kills_lines = logs.flat_map do |line| 
      match_line = line.match(/by (?<mean_of_death>[^\r\n]+)/)
      match_line.nil? ? [] : match_line.named_captures
    end
  end

  def parse_games
    logs
      .slice_after{|line| line.start_with? (/\d?\d:\d{2}\sInitGame/)}
      .map {|game_log| Game.new(get_kills(game_log), get_means_of_death(game_log))}
  end

  def parse_players
    players = get_kills(@logs).flat_map {|kill| kill.values}
                              .select {|player_name| player_name != "<world>"}
                              .uniq
                              .map {|player| Player.new(player)}
  end
end

end
