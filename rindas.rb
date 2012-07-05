#
# Example taken from http://segment7.net/projects/ruby/drb/introduction.html
#
# rindas.rb

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

# Takes requests for a 'sum', processes them and writes the response
loop do
  r = ts.take(['sum', nil, nil])
  v = do_it(r[2])
  puts "A sum #{v}"
  ts.write(['ans', r[1], r[2], v])
end
