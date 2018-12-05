require 'byebug'
require 'benchmark'
require_relative 'linked_list'

module Day3
  LINE_REGEX = /#(?<id>\d+)\D+(?<left>\d+),(?<top>\d+)\D+(?<w>\d+)x(?<h>\d+)/

  def self.get_claim_data(claim_text)
    # Example claim_text: 
    # "#1 @ 100,366: 24x27"
    claim_text.match(LINE_REGEX)
  end

  ## Main
  class Solver
    attr_reader :grid, :valid_claims

    def initialize
      @input_path = './input.txt'
      @grid = Grid.build_empty_grid(@input_path)
      @valid_claims = LinkedList.new
    end

    def part_one
      add_all_claims
      grid.count_overlaps
    end

    def part_two
      add_all_claims

      # There should only be one linkedlist node left
      valid_claims.first.val.id
    end

    def add_all_claims
      # File.foreach(@input_path) do |line|
      `grep "^.*$" #{@input_path}`.split(/\n/).each do |line|
        claim_data = Day3::get_claim_data(line)
        claim = Claim.new(claim_data)

        # insert operation returns the LL Node
        claim_node = valid_claims.insert(claim)
        # let the claim know about its LL Node counterpart
        # this is for O(1) invalidation when it overlaps
        claim.node = claim_node
        claim.add_to_grid(grid)
      end
    end
  end

  ## Grid
  class Grid
    def self.build_empty_grid(filename)
      data = Hash.new { |h, k| h[k] = [] }

      self.new(data)
    end

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def count_overlaps
      data.reduce(0) do |count, (k, v)|
        v.size > 1 ? count + 1 : count
      end
    end

    def invalidate_nodes_in_bucket!(bucket)
      bucket.each(&:invalidate_node)
    end

    def [](pos)
      data[pos]
    end

    def []=(pos, val)
      data[pos] = val
    end
  end

  ## Claim 
  class Claim
    attr_reader :width, :height, :left, :top, :id
    attr_accessor :node

    def initialize(claim_data)
      @width = claim_data[:w].to_i
      @height = claim_data[:h].to_i
      @left = claim_data[:left].to_i + 1
      @top = claim_data[:top].to_i + 1
      @id = claim_data[:id].to_i
    end

    def right_edge
      left + width
    end

    def bottom_edge
      top + height
    end

    def add_to_grid(grid)
      (left..right_edge).each do |x_coord|
        (top..bottom_edge).each do |y_coord|
          pos = x_coord, y_coord
          bucket = grid[pos]
          bucket << FabricSquare.new(x_coord, y_coord, self)

          grid.invalidate_nodes_in_bucket!(bucket) if bucket.size > 1
        end
      end
    end

    def remove_from_valid_list
      unless @removed
        node.remove
        @removed = true
      end
    end
  end

  ## Coord
  class FabricSquare
    attr_reader :x, :y, :claim

    def initialize(x, y, claim)
      @x, @y, @claim = x, y, claim
    end

    def invalidate_node
      claim.remove_from_valid_list
    end
  end
end