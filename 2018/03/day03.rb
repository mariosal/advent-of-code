class Claim
  attr_reader :id, :left, :top, :width, :height

  def initialize(id, left, top, width, height)
    @id = id
    @left = left
    @top = top
    @width = width
    @height = height
  end
end

class Fabric
  attr_reader :claims

  def initialize(claims)
    @claims = claims
    @claims.each do |claim|
      cover(claim)
    end
  end

  def overlaps
    area.keys.reduce(0) do |acc, x|
      acc += area[x].keys.reduce(0) do |acc1, y|
        acc1 += 1 if area[x][y].size > 1
        acc1
      end
      acc
    end
  end

  def intact
    overlapping_ids = area.keys.reduce([]) do |acc, x|
      acc += area[x].keys.reduce([]) do |acc1, y|
        acc1 += area[x][y].map(&:id) if area[x][y].size > 1
        acc1
      end
      acc
    end.uniq

    claims.map(&:id).reject do |id|
      overlapping_ids.include?(id)
    end
  end

  def cover(claim)
    (0...claim.width).each do |x|
      (0...claim.height).each do |y|
        area[claim.left + x][claim.top + y] << claim
      end
    end
  end

  def area
    @area ||= Hash.new do |hash, key|
      hash[key] = Hash.new do |hash1, key1|
        hash1[key1] = []
      end
    end
  end
end

claims = File.read('input03.txt').split("\n").map do |claim|
  Claim.new(*claim.scan(/\d+/).map(&:to_i))
end

p Fabric.new(claims).overlaps
p Fabric.new(claims).intact.sort
