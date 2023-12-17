require './commons/assert'
require 'matrix'
require 'pqueue'
require 'set'

class Node
  attr_reader :pos, :direction, :length

  def initialize(pos, direction, length)
    @pos = pos
    @direction = direction
    @length = length
  end

  def ==(other)
    eql?(other)
  end

  def eql?(other)
    @pos == other.pos &&
      @direction == other.direction &&
      @length == other.length
  end

  def hash
    [@pos, @direction, @length].hash
  end

  def to_s
    "[[#{@pos[0]}, #{@pos[1]}], [#{@direction[0]}, #{@direction[1]}], #{@length}]"
  end

  def to_str
    to_s
  end

  def inspect
    to_s
  end
end

def neigh(grid, node, min, max)
  [Vector[1, 0], Vector[-1, 0], Vector[0, 1], Vector[0, -1]].inject([]) do |neighs, dir|
    next neighs if dir * -1 == node.direction # can't go back

    npos = node.pos + dir
    nlength = dir == node.direction ? node.length + 1 : 1

    # off grid
    next neighs unless npos[0] >= 0 && npos[0] < grid.row_count && npos[1] >= 0 && npos[1] < grid.column_count
    next neighs if nlength > max # too big
    next neighs if dir != node.direction && node.length < min # too small

    neighs << Node.new(npos, dir, nlength)
  end
end

def part_one(input, min = 0, max = 3)
  grid = Matrix[*input.split("\n").map { _1.split('') }].map(&:to_i)
  target = Vector[grid.row_count - 1, grid.column_count - 1]

  costs = {}
  costs[Node.new(Vector[0, 0], Vector[1, 0], 0)] = 0
  costs[Node.new(Vector[0, 0], Vector[0, 1], 0)] = 0

  to_visit = PQueue.new([]) { |a, b| a[1] < b[1] }
  to_visit.push([Node.new(Vector[0, 0], Vector[0, 1], 0), 0])
  to_visit.push([Node.new(Vector[0, 0], Vector[1, 0], 0), 0])

  until to_visit.empty?
    node, cost = to_visit.pop
    return cost if node.pos == target && node.length >= min

    neigh(grid, node, min, max).each do |nnode|
      ncost = costs[node] + grid[*nnode.pos]
      if !costs.key?(nnode) || ncost < costs[nnode]
        costs[nnode] = ncost
        to_visit.push([nnode, ncost])
      end
    end
    # dbg(grid, costs, to_visit)
  end

  #   dbg(grid, costs, to_visit)

  costs[target]
end

def dbg(grid, costs, q)
  p q.top
  x = Matrix.zero(grid.row_count, grid.column_count)
  costs.each { |k, v| x[*k.pos] = v }
  x.row_vectors.each do |v|
    v.each { printf '%4d', _1 }
    puts
  end

  $stdin.gets
end

def part_two(input)
  part_one(input, 4, 10)
end

def test
  example = %(2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533)

  assert part_one(example), 102
  assert part_two(example), 94
  0
end
