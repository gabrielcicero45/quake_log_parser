RSpec.describe LogParser do
  let(:parser) { LogParser.new(file) }

  describe "#parse_games" do 
    context "when there's only one game" do 
      let(:file) { 'spec/fixtures/games.log' }
      it "returns a game list with size equals 1" do 
        expect(parser.parse_games.count).to eq(1)
      end
      it "gets the kills from a log" do 
        expect(parser.get_kills(parser.logs)).to eq([{"killed"=>"Zeh", "killer"=>"<world>"},{"killed"=>"Dono da Bola", "killer"=>"<world>"}])
      end
      it "gets the means of death from a log" do 
        expect(parser.get_means_of_death(parser.logs)).to eq([{"mean_of_death"=>"MOD_TRIGGER_HURT"}, {"mean_of_death"=>"MOD_FALLING"}])
      end
      it "parses the logs to a players list" do 
        expect(parser.parse_players.count).to eq(2)
      end
    end
  end
end