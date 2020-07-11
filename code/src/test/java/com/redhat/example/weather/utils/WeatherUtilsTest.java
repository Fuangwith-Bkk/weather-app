package com.redhat.example.weather.utils;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import com.redhat.example.weather.utils.WeatherUtils;

class WeatherUtilsTest {

	@Test
	public void test_celsius_to_fahrenheit() {
		WeatherUtils utils = new WeatherUtils();
		double expectedF = 212;
		double resultC = utils.celsius2Fahrenheit(100);
		assertEquals(expectedF, resultC);
	}
	
	@Test
	public void test_SSHWS() {
		WeatherUtils utils = new WeatherUtils();
		int wind_speed = 251;
		String result = utils.SSHWS(wind_speed);
		String expected = "Category 4 - Hurricane";
		assertEquals(expected, result);
		
	}

}
