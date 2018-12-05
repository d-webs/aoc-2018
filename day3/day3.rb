require 'byebug'

module Day3
  LINE_REGEX = /#(?<id>\d+)\D+(?<left>\d+),(?<top>\d+)\D+(?<w>\d+)x(?<h>\d+)/

  ## Main
  class Solver
    attr_reader :grid, :claims

    def initialize
      @input_path = './input.txt'
      @grid = Grid.build_empty_grid(@input_path)
      @non_overlapping = nil
      @claims = []
    end

    def part_one
      add_all_claims
      grid.count_overlaps
    end

    def part_two
      add_all_claims
      claims.find(&:no_overlap?).id
    end

    def add_all_claims
      File.foreach(@input_path) do |line|
        claim_data = FileUtil.get_claim_data(line)
        claim = Claim.new(claim_data)
        claim.add_to_grid(grid)
        claims << claim
      end
    end
  end

  ## Grid
  class Grid
    def self.build_empty_grid(filename)
      max_width, max_height = 0, 0

      File.foreach(filename) do |line|
        claim = Claim.new(FileUtil.get_claim_data(line))

        max_width = claim.right_edge if claim.right_edge > max_width
        max_height = claim.bottom_edge if claim.bottom_edge > max_height
      end

      data_height = max_height + 10 # arbitrary padding
      data_width = max_width + 10 # arbitrary padding

      # Create an array of arrays, of arrays. The lowest level
      # array is a bucket to hold coordinates (between 0 - 5 objects)
      data_arr = Array.new(data_height) do
        Array.new(data_width) { Array.new }
      end

      self.new(data_arr)
    end

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def count_overlaps
      data.reduce(0) do |count, row|
        count + row.count { |el| el.length >= 2 }
      end
    end

    def [](pos)
      x, y = pos
      data[x][y]
    end

    def []=(pos, val)
      x, y = pos
      data[x][y] = val
    end
  end

  ## Claim 
  class Claim
    attr_reader :width, :height, :left, :top, :id
    attr_accessor :overlaps

    def initialize(claim_data)
      @width = claim_data[:w].to_i
      @height = claim_data[:h].to_i
      @left = claim_data[:left].to_i
      @top = claim_data[:top].to_i
      @id = claim_data[:id].to_i
      @overlaps = false
    end

    def no_overlap?
      !overlaps
    end

    def right_edge
      left + width
    end

    def bottom_edge
      top + height
    end

    def add_to_grid(grid)
      (left + 1..right_edge).each do |x_coord|
        (top + 1..bottom_edge).each do |y_coord|
          pos = x_coord, y_coord
          bucket = grid[pos]
          bucket << Coordinate.new(x_coord, y_coord, self)

          set_claims_to_overlap!(bucket) if bucket.size > 1
        end
      end
    end

    def set_claims_to_overlap!(bucket)
      bucket.each(&:set_claim_to_overlap)
    end
  end

  ## Coord
  class Coordinate
    attr_reader :x, :y, :claim

    def initialize(x, y, claim)
      @x, @y, @claim = x, y, claim
    end

    def set_claim_to_overlap
      claim.overlaps = true
    end
  end

  ## Util
  class FileUtil
    def self.get_claim_data(claim_text)
      # Example claim_text: 
      # "#1 @ 100,366: 24x27"
      claim_text.match(LINE_REGEX)
    end
  end
end