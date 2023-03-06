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
        int expected = 40;
        int actual = app.sum(10, 20);
        assertEquals(expected, actual);
    }
}
