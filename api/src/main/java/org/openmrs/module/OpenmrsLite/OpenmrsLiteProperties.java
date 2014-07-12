package org.openmrs.module.OpenmrsLite;

import org.openmrs.Location;
import org.openmrs.module.emrapi.utils.ModuleProperties;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.util.Calendar;
import java.util.Date;
import java.util.Locale;


/**
 * Properties for this module.
 */
@Component("coreAppsProperties")
public class OpenmrsLiteProperties extends ModuleProperties {

	// when adding a new patient identifier via the patient dashboard, the location to use if not specified (and the identifier type requires a location)
	public Location getDefaultPatientIdentifierLocation() {
		return getLocationByGlobalProperty(OpenmrsLiteConstants.GP_DEFAULT_PATIENT_IDENTIFIER_LOCATION);
	}

	public int getRecentDiagnosisPeriodInDays() {
		String gp = getGlobalProperty(OpenmrsLiteConstants.GP_RECENT_DIAGNOSIS_PERIOD_IN_DAYS, false);
		if (StringUtils.hasText(gp)) {
			try {
				return Integer.parseInt(gp);
			} catch (NumberFormatException e) {
				throw new IllegalStateException("Invalid configuration: number of days expected in " + OpenmrsLiteConstants.GP_RECENT_DIAGNOSIS_PERIOD_IN_DAYS, e);
			}
		}
		return 730; //2 years
	}

}
