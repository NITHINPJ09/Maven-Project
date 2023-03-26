package com.nithin.app;
import java.util.Scanner;  

public class App 
{
    public static void main(String[] args)
    {
        System.out.println("PROGRAM FOR ADDING TWO NUMBERS");
        App obj = new App();
        int x, y, result;  
        Scanner sc = new Scanner(System.in);  
        System.out.print("Enter the first number: ");  
        x = sc.nextInt();  
        System.out.print("Enter the second number: ");  
        y = sc.nextInt();   
        result = app.sum(x, y);
        System.out.println("Sum : " + result);
    }

    public int sum(int a, int b)
    {
        return a+b;
    }
}
