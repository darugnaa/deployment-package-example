package org.darugna.alessandro.webexample;

import java.io.IOException;
import java.net.URL;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.osgi.service.http.HttpContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class OpenHttpContext implements HttpContext {

	private static final Logger s_logger = LoggerFactory.getLogger(OpenHttpContext.class);
			
	private final HttpContext m_httpContext;
	
	public OpenHttpContext(HttpContext httpContext) {
		m_httpContext = httpContext;
	}

	@Override
	public boolean handleSecurity(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		return true;
	}

	@Override
	public URL getResource(String name) {
		URL url = m_httpContext.getResource(name);
		s_logger.debug("Requested <{}>, resource is {}", name, url);
		return url;
	}

	@Override
	public String getMimeType(String name) {
		return m_httpContext.getMimeType(name);
	}
}
