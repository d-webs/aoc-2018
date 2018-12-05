## Complexity Analysis
## K * (N * N) + (N * N)
module Day3
  LINE_REGEX = /#(?<id>\d+)\D+(?<left>\d+),(?<top>\d+)\D+(?<w>\d+)x(?<h>\d+)/

  ## Main
  class Solver
    attr_reader :grid, :claims

    def initialize
      @input_path = './input.txt'
      @grid = Grid.build_empty_grid(@input_path)
      @claims = []
    end

    def part_one
      add_all_claims
      grid.num_overlaps
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
      data_arr = Array.new(1000) do
        Array.new(1000) { Bucket.new }
      end

      self.new(data_arr)
    end

    attr_reader :data
    attr_accessor :num_overlaps

    def initialize(data)
      @data = data
      @num_overlaps = 0
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

          if bucket.size > 1
            set_claims_to_overlap!(bucket) 
            
            unless bucket.overlapped
              bucket.set_as_overlapped
              grid.num_overlaps += 1
            end
          end
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

  class Bucket 
    attr_reader :data, :overlapped
    def initialize
      @data = []
      @overlapped = false
    end

    def set_as_overlapped
      @overlapped ||= true
    end

    def <<(obj)
      data << obj
    end

    def each
      data.each { |d| yield d }
    end

    def size
      data.size
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