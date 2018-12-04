require 'byebug'

module Day3
  LINE_REGEX = /#(?<id>\d+)\D+(?<left>\d+),(?<top>\d+)\D+(?<w>\d+)x(?<h>\d+)/

  class Day3
    attr_reader :grid

    def initialize
      @input_path = './input.txt'
      @grid = Grid.build_empty_grid(@input_path)
    end

    def part_one
      File.foreach(@input_path) do |line|
        claim_data = FileUtil.get_claim_data(line)
        claim = Claim.new(claim_data)

        claim.add_to_grid(grid)
      end

      grid.count_overlaps
    end
  end

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
      data_arr = Array.new(data_height) { Array.new(data_width, 0) }

      self.new(data_arr)
    end

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def count_overlaps
      data.reduce(0) do |count, row|
        count + row.count { |el| el >= 2 }
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

  class Claim
    attr_reader :width, :height, :left, :top

    def initialize(claim_data)
      @width = claim_data[:w].to_i
      @height = claim_data[:h].to_i
      @left = claim_data[:left].to_i
      @top = claim_data[:top].to_i
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
          pos = [x_coord, y_coord]
          grid[pos] += 1
        end
      end
    end
  end

  class FileUtil
    def self.get_claim_data(claim_text)
      # Example claim_text: 
      # "#1 @ 100,366: 24x27"
      claim_text.match(LINE_REGEX)
    end
  end
end