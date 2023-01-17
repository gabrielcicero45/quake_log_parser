class LogParser
  attr_reader :logs

  def initialize
      @logs = File.foreach('games.log')
  end

  def parse_games
    logs.slice_before(/ShutdownGame/).map {|game| filter_kills(game)}
  end

  def filter_kills(game)
    game.map do |line| 
      match = line.match(/: (?<killer>[^:]+) killed (?<killed>.+) by/) 
      match ? match.named_captures : nil 
    end.compact
  end

  def filter_players(game)
    players_raw = game.flat_map {|kill| kill.flatten}.uniq
    players = players_raw.select {|player| player != "killer" and player != "killed" and player != "<world>"}
  end

  def get_players_score(game)
    players_score = Hash.new(0)
    killers = game.map {|kill| kill["killer"] != "<world>" ? players_score[kill["killer"]] += 1 : nil} 
    suicide_kills = game.select {|kill| kill["killer"] == kill["killed"]}
    suicide_kills.map{|kill| players_score[kill["killer"]] -= 1 } 
    world_kills = game.select {|kill| kill["killer"] == "<world>" } 
    world_kills.map{|kill| players_score[kill["killed"]] -= 1 } 
    return players_score
  end

  def match_summarize(match_id)
    match = parse_games[match_id]
    total_kills = match.count
    players = filter_players(match)
    players_score = get_players_score(match)
    result = {"game_#{match_id}" => {:total_kills => total_kills, :players => players, :kills => players_score}}
  end
end