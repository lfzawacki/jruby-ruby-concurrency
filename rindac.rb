#
# Example taken from http://segment7.net/projects/ruby/drb/introduction.html
#
# rindac.rb

require 'rinda/ring'

def do_it(v)
  puts "do_it(#{v})"
  v + v
end

DRb.start_service

# Finds the tuple space via the ring server
ring_server = Rinda::RingFinger.primary

ts = ring_server.read([:name, :TupleSpace, nil, nil])[2]
ts = Rinda::TupleSpaceProxy.new ts

# Writes requests for a 'sum'
(1..10).each do |n|
  ts.write(['sum', DRb.uri, n])
end

# Takes the answers from the tuple space, blocks if it's not there
(1..10).each do |n|
  ans = ts.take(['ans', DRb.uri, n, nil])
  p [ans[2], ans[3]]
end
