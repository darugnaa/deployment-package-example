package org.darugna.alessandro.example.impl;

import java.util.Date;
import java.util.Map;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import org.darugna.alessandro.example.MyService;
import org.eclipse.kura.KuraException;
import org.eclipse.kura.cloud.CloudClient;
import org.eclipse.kura.cloud.CloudService;
import org.eclipse.kura.configuration.ConfigurableComponent;
import org.eclipse.kura.message.KuraPayload;
import org.osgi.service.component.ComponentContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class MyServiceImpl implements ConfigurableComponent, MyService {
	
	private static final Logger s_logger = LoggerFactory.getLogger(MyServiceImpl.class);

	// Threading and workers handlers
	private ScheduledThreadPoolExecutor m_scheduledExecutor;
	
	// Cloud and connection
	private CloudService m_cloudService;
	private CloudClient m_cloudClient;
	
	// ----------------------------------------------------------------
	//
	//   Dependencies
	//
	// ----------------------------------------------------------------
	
	public void setCloudService(CloudService cloudService) {
		m_cloudService = cloudService;
	}

	public void unsetCloudService(CloudService cloudService) {
		m_cloudService = null;
	}
	
	// ----------------------------------------------------------------
	//
	//   Activation APIs
	//
	// ----------------------------------------------------------------
	
	protected void activate(ComponentContext componentContext, Map<String,Object> properties) {
		s_logger.info("Activating");
		doUpdate(properties);
	}
	
	protected void deactivate(ComponentContext componentContext) {
		s_logger.info("Deactivating");
		doDeactivate();
		m_scheduledExecutor.shutdownNow();
	}
	
	public void update(Map<String,Object> properties) {
		s_logger.info("Updating");
		doDeactivate();
		doUpdate(properties);
	}
	
	private void doUpdate(Map<String,Object> properties) {
		for (String s : properties.keySet()) {
			s_logger.debug("Update - {}: {}", s, properties.get(s));
		}
		
		Boolean enabled = (Boolean) properties.get("enabled");
		if (!enabled) {
			return;
		}
		
		// Instantiate a new ScheduledThreadPoolExecutor at every update.
		m_scheduledExecutor = new ScheduledThreadPoolExecutor(1);
		
		Runnable publishRunnable = new Runnable() {		
			@Override
			public void run() {
				try {
					doPublish();
				} catch (Throwable t) {
					s_logger.error("Unexpected Throwable", t);
				}
			}
		};
		m_scheduledExecutor.scheduleAtFixedRate(publishRunnable, 0,
				20, TimeUnit.SECONDS);

	}
	
	private void doDeactivate() {
		if (m_scheduledExecutor != null) {
			// Shutdown the ScheduledThreadPoolExecutor.
			// No new threads will be accepted.
			s_logger.debug("Shutting down the ScheduledThreadPoolExecutor");
			m_scheduledExecutor.shutdown();
			try {
				m_scheduledExecutor.awaitTermination(10, TimeUnit.SECONDS);
			} catch (InterruptedException e) {
				s_logger.warn("Unexpected state, one or more threads may continue to run");
			}
		}

		m_cloudClient.release();
	}
	
	// ----------------------------------------------------------------
	//
	//   Worker methods
	//
	// ----------------------------------------------------------------
	

	private void doPublish() throws KuraException {
		s_logger.debug("doPublish");
		if (m_cloudClient == null) {
			m_cloudClient = m_cloudService.newCloudClient("MyService");
		}
		
		KuraPayload payload = new KuraPayload();
		payload.addMetric("Hello", "World");
		payload.setTimestamp(new Date());
		m_cloudClient.publish("myservice", payload, 0, false);
	}

	
	@Override
	public String doStuff(String parameter) {
		return "Hello " + parameter;
	}
	

}
