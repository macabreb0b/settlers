# -*- coding: utf-8 -*-

require 'rspec'
require 'catan'

describe Game do
  let(:p1) {Player.new("Phil")}
  let(:p2) {Player.new("Bernie")}
  let(:p3) {Player.new("Quality")}
  let(:p4) {Player.new("Mattress")}
  subject(:game) { Game.new(p1, p2, p3, p4)}

  before { game.assign_colors }

  context "when starting a game" do
    it "gives each player a color" do
      expect( game.players.all? { |player| !player.color.nil? } ).to be true
    end
  end


  context "when starting a turn" do

    it "pays players for their settlements" do
      p1.build_settlement("H2", true)
      p1.build_settlement("H3", true)
      p1.build_settlement("J2", true)
      resource = game.board[[7, 4]].resource
      number = game.board[[7,4]].number
      game.board.payout(number)

      expect(p1.resources[resource]).to eq(3)
    end

  end

end