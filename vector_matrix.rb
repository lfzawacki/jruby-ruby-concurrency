#
# => Matrix and Vector product using muliple threads in Ruby
#       To execute just type: ruby vector_matrix.rb 


# Code used to read the matrix and the vector from a text file
# See build_input.rb for specifics
def read_matrix
    file = File.open("matrix.txt", "r")
    matrix = []
    line = ""

    while line = file.gets
        matrix << line.split.map { |i| i.to_i }
    end
    matrix
end

def read_vector
    vector = IO.read("vector.txt")
    vector.split.map { |i| i.to_i }
end

MATRIX = read_matrix
VECTOR = read_vector
answer = []

total_size = MATRIX.size

nprocs = [1, 2, 4]

# Calculate the product using 1, 2 and 4 threads and measure the time
nprocs.each do |nproc|

    threads = []
    puts "N is #{total_size} and I'm using #{nproc} threads"

    startt = Time.now
    0.upto(nproc-1) do |p|

        # Creates a new thread
        size = total_size/nproc
        t = Thread.new do

            # Give a range [a,b] of lines for every thread to calculate
            a, b = p*size, (p+1)*size - 1

            # Calculates part of the product
            (a).upto(b) do |i|
                answer[i] = 0
                0.upto(total_size-1) do |j|
                    answer[i] += MATRIX[i][j] * VECTOR[j];
                end
            end
        end

        threads << t
    end

    # Wait for all threads to finish
    threads.each do |t| t.join end
    endt = Time.now

    # Let's see the elapsed time
    puts "Time: #{(endt-startt)}"
end