#
# Example taken from http://segment7.net/projects/ruby/drb/introduction.html
#
# Receives the url of the DRb server in the comand line

require 'drb'

# Creates an Undumped class
# Calls will be made back to it's methods and it won't be
# serialized and transmited to the other endpoint
Point = Struct.new 'Point', :x, :y
class Point
  include DRbUndumped

  def to_s
    "(#{x}, #{y})"
  end
end

# Start DRb get a new server object and use it
DRb.start_service
dist_calc = DRbObject.new nil, ARGV.shift

p1 = Point.new 0, 0
p2 = Point.new 1, 0

puts "The distance between #{p1} and #{p2} is #{dist_calc.find_distance p1, p2}"
