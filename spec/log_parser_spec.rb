RSpec.describe LogParser do
  parser = LogParser.new
  game = parser.parse_games
  it "has total_kills in first game" do 
    expect(game[0].get_kills().count).to eq(5)
  end
  #it "returns the players from the first game" do
  #  expect(game[0].get_players()).to eq(["Isgalamido","Fulano"])
  #end
  it "summarizes first match " do
    expect(game[0].game_summarize).to eq({:kills=>["Isgalamido: -3","Fulano: 2"], :players=>["Isgalamido","Fulano"], :total_kills=>5})
  end
end