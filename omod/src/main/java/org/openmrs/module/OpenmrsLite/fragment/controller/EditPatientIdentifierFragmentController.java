package org.openmrs.module.OpenmrsLite.fragment.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.Location;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifier;
import org.openmrs.PatientIdentifierType;
import org.openmrs.api.IdentifierNotUniqueException;
import org.openmrs.api.InvalidCheckDigitException;
import org.openmrs.api.InvalidIdentifierFormatException;
import org.openmrs.api.PatientService;
import org.openmrs.module.OpenmrsLite.OpenmrsLiteProperties;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.action.FailureResult;
import org.openmrs.ui.framework.fragment.action.FragmentActionResult;
import org.openmrs.ui.framework.fragment.action.SuccessResult;
import org.openmrs.validator.PatientIdentifierValidator;
import org.springframework.web.bind.annotation.RequestParam;

/**
 */
public class EditPatientIdentifierFragmentController {
	
	public FragmentActionResult editPatientIdentifier(UiUtils ui,
	                                                  @RequestParam("patientId") Patient patient,
	                                                  @RequestParam("identifierTypeId") PatientIdentifierType identifierType,
	                                                  @RequestParam(value = "identifierValue", required = false) String identifierValue,
	                                                  @RequestParam(value = "locationId", required = false) Location location,
	                                                  @SpringBean("patientService") PatientService patientService,
                                                      @SpringBean("OpenmrsLiteProperties") OpenmrsLiteProperties OpenmrsLiteProperties) {
		
		if (patient != null && identifierType != null) {
			PatientIdentifier patientIdentifier = patient.getPatientIdentifier(identifierType);
			if (patientIdentifier == null && StringUtils.isBlank(identifierValue)) {
				//nothing to do
				return new SuccessResult(ui.message("emr.patientDashBoard.editPatientIdentifier.warningMessage"));
			}

            // create new identifier if necessary
			if (patientIdentifier == null) {
				patientIdentifier = new PatientIdentifier(identifierValue, identifierType, location);
			} else {
                // otherwise update identifier value and location
				if (StringUtils.isNotBlank(identifierValue)) {
					patientIdentifier.setIdentifier(identifierValue);
				} else {
					patientIdentifier.setVoided(true);
				}
                if (location != null) {
                    patientIdentifier.setLocation(location);
                }
			}

            // assure that a location has been set if required
            if (patientIdentifier.getLocation() == null
                    && !PatientIdentifierType.LocationBehavior.NOT_USED.equals(patientIdentifier.getIdentifierType().getLocationBehavior())) {
                patientIdentifier.setLocation(OpenmrsLiteProperties.getDefaultPatientIdentifierLocation());
            }

            // validate the identifier
            try {
                PatientIdentifierValidator.validateIdentifier(patientIdentifier);
            }
            catch (IdentifierNotUniqueException e) {
                return new FailureResult(ui.format(identifierType) + " "
                        + ui.message("OpenmrsLite.patientDashBoard.editPatientIdentifier.duplicateMessage"));
            }
            catch (InvalidCheckDigitException e) {
                return new FailureResult(ui.format(identifierType) + " "
                        + ui.message("OpenmrsLite.patientDashBoard.editPatientIdentifier.invalidMessage"));
            }
            catch (InvalidIdentifierFormatException e) {
                return new FailureResult(ui.format(identifierType) + " "
                        + ui.message("OpenmrsLite.patientDashBoard.editPatientIdentifier.invalidFormatMessage")
                        + " \"" + identifierType.getFormatDescription() + "\"");
            }
            catch (Exception e) {
                return new FailureResult(ui.message("OpenmrsLite.patientDashBoard.editPatientIdentifier.failureMessage") + " "
                        + ui.format(identifierType));
            }

            // now go ahead and save
			patient.addIdentifier(patientIdentifier);
			try {
                patientService.savePatient(patient);
			}
			catch (Exception e) {
				return new FailureResult(ui.message("OpenmrsLite.patientDashBoard.editPatientIdentifier.failureMessage") + " "
                        + ui.format(identifierType));
			}
		}
		return new SuccessResult(ui.format(identifierType) + " "
                + ui.message("OpenmrsLite.patientDashBoard.editPatientIdentifier.successMessage"));
	}
}
