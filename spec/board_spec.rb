# -*- coding: utf-8 -*-

require 'rspec'
require 'catan'
require 'colorize'

describe Board do
  let(:game) { Game.new()}
  subject(:board) { Board.new(game) }

  context "after initialization" do
    it "has the right amount of roads" do
      expect(board.rds.count).to eq(72)
    end

    it "has the right amount of tiles" do
      expect(board.find_all(Tile).uniq.count).to eq(19)
    end

    it "has the right amount of intersections" do
      expect(board.find_all(Intersection).count).to eq(54)
    end

    it "finds intersections by their number" do
      expect( board.intersection_at("E2") ).to be_a(Intersection)
    end

    it "finds the neighbors of intersections and tiles" do
      e2 = board.intersection_at("E2")
      expect(e2.neighboring(Intersection).map{ |ixs| ixs.number }.join(' ') )
        .to eq("D2 F2 F3")
    end
  end

  context "when game is in progress" do
    it "finds the longest road"

    it "finds the largest army"
  end

end