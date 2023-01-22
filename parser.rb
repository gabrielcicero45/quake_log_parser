require './game.rb'
class LogParser
  attr_reader :logs

  def initialize(path)
      @logs = File.foreach(path)
  end

  def parse_games
    logs.slice_before(/ShutdownGame/).map {|game| Game.new(logs)}
  end

  def logs_summarize
    parse_games().each_with_index.map{|game,index| {"game_#{index}" => game.game_summarize}}
  end
end
