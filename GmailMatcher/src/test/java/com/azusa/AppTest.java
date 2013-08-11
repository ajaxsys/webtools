package com.azusa;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * Unit test for simple App.
 */
public class AppTest
    extends TestCase
{
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public AppTest( String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( AppTest.class );
    }

    /**
     * Rigourous Test :-)
     */
    public void testApp()
    {
        assertTrue( true );
        String[] args = new String[] {"chuanlinyan@gmail.com","19830808","メールdeポイント","\\bhttp[s]*://?pmrd.rakuten.co.jp/\\?r=.+?p=.+?u=.+?\\b"};
        try {
			GmailMatcher.main(args);
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
}
