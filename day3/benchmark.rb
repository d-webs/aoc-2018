require_relative 'day3'

if __FILE__ == $PROGRAM_NAME
  puts "count: #{Day3::Solver.new.part_one}"
  puts "id: #{Day3::Solver.new.part_two}"

  part_one_times = []
  10.times do 
    s = Time.now
    Day3::Solver.new.part_one
    e = Time.now 

    part_one_times << (e - s)
  end

  part_two_times = []
  10.times do 
    s = Time.now
    Day3::Solver.new.part_two
    e = Time.now 

    part_two_times << (e - s)
  end

  puts "avg p1: %s" % (part_one_times.reduce(:+) / part_one_times.length)
  puts "avg p2: %s" % (part_two_times.reduce(:+) / part_two_times.length)
end