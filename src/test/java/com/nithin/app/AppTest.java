package com.nithin.app;

import static org.junit.Assert.assertEquals;

import org.junit.Test;


/**
 * Unit test for simple App.
 */
public class AppTest 
{
    App app = new App();
    /**
     * Rigorous Test :-)
     */
    @Test
    public void testSum()
    {
        int expected = 30;
        int actual = app.sum(50, 20);
        assertEquals(expected, actual);
        expected = 20;
        actual = app.sum(40, 20);
        assertEquals(expected, actual);
    }
}
