jruby-ruby-concurrency
======================

We've got some examples of distributed and parallel programming using Ruby, JRuby and Java here:

* Ruby Drb client-server example
* Rinda RingServer + Tuple Space example
* Concurrent Matrix-Vector multiplication on Ruby, Java and Distributed Ruby with Rinda

## DRb examples how-to

1. Run `drb_server.rb`
2. Copy the uri it prints
3. Run `drb_client.rb <uri>` with the uri from the last step

## Rinda how-to

1. Run `rinda_ts.rb`
2. Run `rinda_server.rb`
3. Run `rinda_client.rb`

## Vector-Matrix multiplication how-to

Don't forget to run `build_input.rb <n>` to create an NxN matrix and a vector to
use in the multiplication (in the files 'matrix.txt' and 'vector.txt' respectively).

### Java how-to

1. Compile VectorMatrix.class
2. Run `java VectorMatrix <N>` where N is the size of the matrix

### Ruby how-to

1. Run `vector_matrix.rb`

### Distributed Ruby how-to

1. Run `rinda_ts.rb`
2. Run the script `ruby dist_vector_matrix.rb <NPROC> <ID>` once for each process.

An example execution for two processes would be:

    ruby rinda_ts.rb
    ruby dist_vector_matrix 2 0 & # creates process 0
    ruby dist_vector_matrix 2 1 & # creates process 1

And for 4 processes:

    ruby rinda_ts.rb
    ruby dist_vector_matrix 4 0 &
    ruby dist_vector_matrix 4 1 &
    ruby dist_vector_matrix 4 2 &
    ruby dist_vector_matrix 4 3 &

Notice the bash `&` operator, it's important to use it so the each script won't wait
for the other to finish to execute.