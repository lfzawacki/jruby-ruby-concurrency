#
# => Matrix and Vector product in Ruby using muliple processes 
# => communicating via tuplespace. Very similar to vector_matrix.rb 
#       To execute just type, for each process: ruby dist_vector_matrix.rb <nproc> <id>
#       Don't forget to start the rinda tuplespace server, using: ruby rinda_ts.rb

require 'rinda/ring'

def read_matrix
    file = File.open("matrix.txt", "rb")
    matrix = []

    while line = file.gets
        matrix << line.split.map { |i| i.to_i }
    end
    file.close
    matrix
end

def read_vector
    vector = IO.read("vector.txt")
    vector.split.map { |i| i.to_i }
end

if ARGV.size < 2
    puts "      usage: ruby dist_vector_matrix.rb <nproc> <id>"
    exit 1
end

# Initialize Rinda service and tuplespace
DRb.start_service

ring_server = Rinda::RingFinger.primary

ts = ring_server.read([:name, :TupleSpace, nil, nil])[2]
ts = Rinda::TupleSpaceProxy.new ts

# Command line arguments, number of processes and process id
nproc = ARGV[0].to_i
id = ARGV[1].to_i

# Data, 0 will distribute it
matrix = nil
vector = nil
answer = []

# Variables to measure time
startt, endt = 0, 0

# Process 0 distributes the work
if id == 0

    # Get data
    matrix = read_matrix
    vector = read_vector
    answer = []

    # Get starting time
    startt = Time.now
    size = matrix.size/nproc

    1.upto(nproc-1) do |i|
        ts.write ['data', i, matrix[i*size,size], vector]
    end
end


# Synchronization: all other processes wait for 0 to give them work
# Problem size will be matrix.size/nproc for everyone 
if id != 0
    tuple = ts.take ['data', id, nil, nil]
    matrix, vector = tuple[2], tuple[3]
    total_size = matrix.size
else
    total_size = matrix.size/nproc
end

puts "I'm #{id}"
puts "I'll calculate #{total_size} lines"

(0).upto(total_size-1) do |i|
    answer[i] = 0
    0.upto(vector.size-1) do |j|
        answer[i] += matrix[i][j] * vector[i];
    end
end

# All processes tell 0 they're done
ts.write ['result', id, true]

if id == 0

    # Synchronization: 0 checks if everyone is done and sends a termination message
    0.upto(nproc-1) do |i|
        ts.take ['result', i, nil]
        puts "#{i} is done!"
        ts.write ['terminate', i]
    end

    # Get finishing time
    endt = Time.now
    puts "Time: #{endt - startt}"
end

tuple = ts.take ['terminate', id]
exit
