package com.nithin.app;

import java.util.Scanner;  

// import Cowsay class from the library
import com.github.ricksbrown.cowsay.Cowsay;

public class App 
{
    public static void main( String[] args )
    {
        System.out.println( "Welcome to DevOps!" );
        App app = new App();
        int x, y, sum;  
        Scanner sc = new Scanner(System.in);  
        System.out.print("Enter the first number: ");  
        x = sc.nextInt();  
        System.out.print("Enter the second number: ");  
        y = sc.nextInt();   
        sum = app.sum(x, y);
        System.out.println( "Sum : " + sum);
    }

    public int sum(int a, int b)
    {
        return a+b;
    }
}
