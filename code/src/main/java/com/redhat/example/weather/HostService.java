package com.redhat.example.weather;

import java.net.InetAddress;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

@Path("host")
public class HostService {

	@GET
    @Produces(MediaType.APPLICATION_JSON)
	public HostInfo getHostName() {
		HostInfo info = new HostInfo();
		try {
			String hostName = InetAddress.getLocalHost().getHostName();
			info.setHostName(hostName);
		}catch(Exception ex) {
			info.setErrorMessage(ex.getMessage());
		}
		return info;
	}
}
