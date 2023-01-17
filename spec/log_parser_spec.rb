RSpec.describe LogParser do
  parser = LogParser.new
  game = parser.parse_games[0]
  it "has total_kills in first game" do 
    expect(parser.parse_games[0].count).to eq(5)
  end
  it "returns the players" do
    expect(parser.filter_players(game)).to eq(["Isgalamido","Fulano"])
  end
  it "summarizes first match " do
    expect(parser.match_summarize(0)).to eq({"game_0"=>{:kills=>{"Isgalamido"=>-2,"Fulano"=>2}, :players=>["Isgalamido","Fulano"], :total_kills=>5}})
  end
end