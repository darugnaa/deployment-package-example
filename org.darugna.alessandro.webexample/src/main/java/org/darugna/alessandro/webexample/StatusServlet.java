package org.darugna.alessandro.webexample;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Random;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@SuppressWarnings("serial")
public final class StatusServlet extends HttpServlet {

	private static final Logger s_logger = LoggerFactory.getLogger(StatusServlet.class);
	private static final Random r = new Random();
			
// 	http://stackoverflow.com/questions/2010990/how-do-you-return-a-json-object-from-a-java-servlet
	
	public final void doGet(HttpServletRequest request, HttpServletResponse response) {
		response.setContentType("application/json");
		PrintWriter out = null;
		HashMap<String,Object> map = new HashMap<>();
		map.put("Hello", "World");
		map.put("EnjoyLevel", r.nextInt(10000));
		try {
			out = response.getWriter();
		} catch (IOException e) {
			s_logger.error("Servlet Error", e);
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			return;
		}
		// Assuming your json object is **jsonObject**, perform the following, it will return your json object
		JSONObject json = new JSONObject(map);
		out.print(json.toString());
		out.flush();
	}
}
