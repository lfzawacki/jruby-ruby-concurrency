#
# Example taken from http://segment7.net/projects/ruby/drb/introduction.html
#
# Rinda RingServer


require 'rinda/ring'
require 'rinda/tuplespace'

# start DRb
DRb.start_service

# Create a TupleSpace to hold named services, and start running
Rinda::RingServer.new Rinda::TupleSpace.new

ts = Rinda::TupleSpace.new

provider = Rinda::RingProvider.new :TupleSpace, ts, 'Tuple Space'
provider.provide

# Wait until the user explicitly kills the server.
DRb.thread.join

