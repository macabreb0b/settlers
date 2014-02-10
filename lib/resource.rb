class Resource < Tile
  FREQ = {
    brick: 3,
    wood: 4,
    desert: 1,
    sheep: 4,
    ore: 3,
    wheat: 4
  }

  SYMBOLS = {
    2 => "②",
    3 => "③",
    4 => "④",
    5 => "⑤",
    6 => "⑥",
    7 => "⑦",
    8 => "⑧",
    9 => "⑨",
    10 => "⑩",
    11 => "⑪",
    12 => "⑫"
  }

  attr_accessor :resource, :number, :robber

  def initialize(resource, number, robber = false)
    @resource, @number = resource, number
    @robber = robber
  end

  def self.freqs
    FREQ
  end

  def short
    case resource
    when :brick then "BK"
    when :wood then "LG"
    when :desert then "DT"
    when :sheep then "SH"
    when :ore then "OR"
    when :wheat then "WH"
    else
      "?"
    end
  end

  def to_s
    return "⛄" if robber
    SYMBOLS[number] || " "
  end
end