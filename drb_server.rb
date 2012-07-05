# Example taken from http://segment7.net/projects/ruby/drb/introduction.html
#

require 'drb'

# A class that uses 2 point objects to calculate a distance
class DistCalc
  def find_distance(p1, p2)
    Math.sqrt((p1.x - p2.x)**2 + (p1.y - p2.y)**2)
  end
end

# Start serving this object
DRb.start_service nil, DistCalc.new

# Print our uri so the client can be run
puts DRb.uri

DRb.thread.join
