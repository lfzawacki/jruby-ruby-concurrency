import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.File;
import java.util.Scanner;

public class VectorMatrix {

    static private int [] matrix;
    static private int [] vector;
    static private int [] answer;

    static private int size;

    static void readInput(int n) throws java.io.FileNotFoundException {

        Scanner scanner = new Scanner(new File("matrix.txt"));
        matrix = new int [n*n];
        vector = new int [n];
        answer = new int [n];

        int i = 0;
        int j = -1;

        while(scanner.hasNextInt()){

           if ((i % n) == 0)
           {
               j += 1;
               i = 0;
           }

           matrix[j*n + i] = scanner.nextInt();

           i += 1;
        }

        scanner = new Scanner(new File("vector.txt"));

        i = 0;
        while(scanner.hasNextInt()) {
            vector[i++] = scanner.nextInt();
        }
    }

    public static void main(String[] args) {

        long startt, endt;
        final int size = Integer.parseInt(args[0]);

        try
        {
            VectorMatrix.readInput(size);
        }
        catch (java.io.FileNotFoundException e)
        {
            System.out.println(e);
            System.out.println("Too bad, probably matrix.txt or vector.txt is missing!");
        }

        Thread [] thread_obj = new Thread[4];
        int threads[] = {1, 2, 4};

        for (int t = 0; t < 3; t++)
        {
            startt = System.currentTimeMillis();
            for (int nt = 0; nt < threads[t]; nt++)
            {
                final int tsize = size/threads[t];
                final int a = t*tsize;
                final int b = (t+1)*tsize;

                thread_obj[nt] = new Thread() {

                    public void run(){
                        for (int i = a; i < b; i++)
                        {
                            answer[i] = 0;
                            for (int j = 0; j < size; j++)
                                answer[i] += vector[j] * matrix[i + j*size];
                        }
                    }

                };
                thread_obj[nt].start();
            }

            try
            {
                for (int nt = 0; nt < threads[t]; nt++)
                    thread_obj[nt].join();
            }
            catch (java.lang.InterruptedException e)
            {
                System.out.println(e);
            }

            endt = System.currentTimeMillis();

            System.out.println("Time: " + (endt - startt)/1000.0);
        }
    }
}