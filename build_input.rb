# * build_input.rb
# => Builds an NxN matrix and a vector to use in
# => the product algorithm
#    To execute use: ruby build_input.rb N

def make_vector n
    (1..n).to_a.map { |i| rand(10) * -1**(rand(i)%2) }
end

if ARGV[0].nil?
    puts 'Give me the size of the matrix'
    exit
end

n = ARGV[0].to_i

matrix = (1..n).to_a.map do
    make_vector(n)
end

File.open("matrix.txt", "w") do |f|
    matrix.each { |l| f.puts l.join " " }
end

File.open("vector.txt", "w") { |f| f.puts make_vector(n).join " " }