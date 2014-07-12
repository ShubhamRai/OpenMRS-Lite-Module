package org.openmrs.module.OpenmrsLite.page.controller.findpatient;

import org.openmrs.module.appframework.domain.AppDescriptor;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 *
 */
public class FindPatientPageController {
	
	/**
	 * This page is built to be shared across multiple apps. To use it, you must pass an "app"
	 * request parameter, which must be the id of an existing app that is an instance of
	 * OpenmrsLite.template.findPatient
	 * 
	 * @param model
	 * @param app
	 * @param sessionContext
	 */
	public void get(PageModel model, @RequestParam("app") AppDescriptor app, UiSessionContext sessionContext) {
		model.addAttribute("afterSelectedUrl", app.getConfig().get("afterSelectedUrl").getTextValue());
		model.addAttribute("heading", app.getConfig().get("label").getTextValue());
		model.addAttribute("label", app.getConfig().get("label").getTextValue());
        model.addAttribute("showLastViewedPatients", app.getConfig().get("showLastViewedPatients").getBooleanValue());
	}
	
}
