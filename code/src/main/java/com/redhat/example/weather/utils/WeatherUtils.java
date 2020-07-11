package com.redhat.example.weather.utils;

public class WeatherUtils {

	public double celsius2Fahrenheit(double celsius) {
		return (celsius * 9/5) + 32;
	} 
	
	//km/h
	public String SSHWS(double wind_speed) {
		if(wind_speed >= 252) {
			return "Category 5 - the highest category of the Saffir–Simpson scale.";
		}else if(wind_speed >= 209 && wind_speed<= 251) {
			return "Category 4 - Hurricane";
		}else if(wind_speed >= 178 && wind_speed<= 208) {
			return "Category 3 - Devastating damage will occur";
		}else if(wind_speed >= 154 && wind_speed<= 177) {
			return "Category 2 - Extremely dangerous winds will cause extensive damage";
		}else if(wind_speed >= 119 && wind_speed<= 153) {
			return "Category 1 - Very dangerous winds will produce some damage";
		}else {
			return "Normal wind.";
		}
	}
}
