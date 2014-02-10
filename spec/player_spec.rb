require 'rspec'
require 'player'

describe Player do

  let(:p1) {Player.new("Phil")}
  let(:p2) {Player.new("Bernie")}
  let(:p3) {Player.new("Quality")}
  let(:p4) {Player.new("Mattress")}
  subject(:game) { Game.new(p1, p2, p3, p4)}

  before { game.assign_colors }

  context "when building structures" do
    before do
      p1.build_settlement("H2", true)
      p1.build_road(["H2", "G3"])
      p1.build_road(["G3", "F3"])
    end

    it "doesn't let player build adjacent settlments" do
      expect{ p1.build_settlement("G3") }.to raise_error
    end

    it "doesn't let players build roads on empty tiles" do
      expect{ p2.build_road(["G3", "F3"]) }.to raise_error
    end

    it "doesn't let player build road off of another player's settlement" do
      p2.build_settlement("F3")
      expect{ p1.build_road(["F3", "E3"]) }.to raise_error
    end
  end
end