package com.nithin.app;

import static org.junit.Assert.assertEquals;




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
        int actual = app.sum(10, 20);
        assertEquals(expected, actual);
    }
}
