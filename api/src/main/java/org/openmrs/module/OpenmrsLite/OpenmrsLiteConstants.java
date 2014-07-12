package org.openmrs.module.OpenmrsLite;

public class OpenmrsLiteConstants {

	public static final String MODULE_ID = "OpenmrsLite";
	 
	public static final String HOME_PAGE_EXTENSION_POINT_ID = "org.openmrs.OpenmrsLite.homepageLink";


    public static final String GP_DEFAULT_PATIENT_IDENTIFIER_LOCATION = "OpenmrsLite.defaultPatientIdentifierLocation";

    public static final String HTMLFORMENTRY_ENCOUNTER_DIAGNOSES_TAG_NAME = "encounterDiagnoses";
    public static final String HTMLFORMENTRY_ENCOUNTER_DISPOSITION_TAG_NAME = "encounterDisposition";
    public static final String HTMLFORMENTRY_ENCOUNTER_DIAGNOSES_TAG_INCLUDE_PRIOR_DIAGNOSES_ATTRIBUTE_NAME = "includePriorDiagnosesFromMostRecentEncounterWithDispositionOfType";


    public static final String VITALS_ENCOUNTER_TYPE_UUID = "67a71486-1a54-468f-ac3e-7091a9a79584";

    public static final String PRIVILEGE_PATIENT_DASHBOARD = "App: OpenmrsLite.patientDashboard";
	public static final String PRIVILEGE_START_VISIT = "Task: OpenmrsLite.createVisit";
	public static final String PRIVILEGE_END_VISIT = "Task: OpenmrsLite.endVisit";

	public static final String GP_RECENT_DIAGNOSIS_PERIOD_IN_DAYS = "OpenmrsLite.recentDiagnosisPeriodInDays";

    public static final String ENCOUNTER_TEMPLATE_EXTENSION = "org.openmrs.OpenmrsLite.encounterTemplate";
}
