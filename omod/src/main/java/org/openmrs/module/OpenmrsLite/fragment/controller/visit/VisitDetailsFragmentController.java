/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */
package org.openmrs.module.OpenmrsLite.fragment.controller.visit;

import org.apache.commons.lang.time.DateFormatUtils;
import org.openmrs.Encounter;
import org.openmrs.User;
import org.openmrs.Visit;
import org.openmrs.api.APIAuthenticationException;
import org.openmrs.api.EncounterService;
import org.openmrs.api.LocationService;
import org.openmrs.api.VisitService;
import org.openmrs.api.context.Context;
import org.openmrs.module.appframework.context.AppContextModel;
import org.openmrs.module.appframework.domain.Extension;
import org.openmrs.module.appframework.feature.FeatureToggleProperties;
import org.openmrs.module.appframework.service.AppFrameworkService;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.OpenmrsLite.OpenmrsLiteConstants;
import org.openmrs.module.OpenmrsLite.contextmodel.VisitContextModel;
import org.openmrs.module.OpenmrsLite.parser.ParseEncounterToJson;
import org.openmrs.module.emrapi.EmrApiConstants;
import org.openmrs.module.emrapi.EmrApiProperties;
import org.openmrs.module.emrapi.disposition.DispositionService;
import org.openmrs.module.emrapi.encounter.EncounterDomainWrapper;
import org.openmrs.module.emrapi.visit.VisitDomainWrapper;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.annotation.SpringBean;
import org.openmrs.ui.framework.fragment.action.FailureResult;
import org.openmrs.ui.framework.fragment.action.FragmentActionResult;
import org.openmrs.ui.framework.fragment.action.SuccessResult;
import org.springframework.web.bind.annotation.RequestParam;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

public class VisitDetailsFragmentController {



    public SimpleObject getVisitDetails(@SpringBean("emrApiProperties") EmrApiProperties emrApiProperties,
                                        @SpringBean("appFrameworkService") AppFrameworkService appFrameworkService,
                                        @SpringBean("encounterService") EncounterService encounterService,
                                        @RequestParam("visitId") Visit visit, UiUtils uiUtils,
                                        UiSessionContext sessionContext) throws ParseException {

        ParseEncounterToJson parseEncounterToJson = new ParseEncounterToJson(appFrameworkService, uiUtils, encounterService);

        SimpleObject simpleObject = SimpleObject.fromObject(visit, uiUtils, "id", "location");

        User authenticatedUser = sessionContext.getCurrentUser();

        boolean canDeleteVisit = authenticatedUser.hasPrivilege(EmrApiConstants.PRIVILEGE_DELETE_VISIT);

        Date startDatetime = visit.getStartDatetime();
        Date stopDatetime = visit.getStopDatetime();

        simpleObject.put("startDatetime", DateFormatUtils.format(startDatetime, "dd MMM yyyy hh:mm a", Context.getLocale()));

        if (stopDatetime != null) {
            simpleObject.put("stopDatetime",
                    DateFormatUtils.format(stopDatetime, "dd MMM yyyy hh:mm a", Context.getLocale()));
        } else {
            simpleObject.put("stopDatetime", null);
        }

        VisitDomainWrapper visitWrapper = new VisitDomainWrapper(visit, emrApiProperties);

        List<SimpleObject> encounters = new ArrayList<SimpleObject>();
        for (Encounter encounter : visitWrapper.getSortedEncounters()) {
            encounters.add(parseEncounterToJson.createEncounterJSON(authenticatedUser, encounter));
        }
        simpleObject.put("encounters", encounters);

        simpleObject.put("admitted", visitWrapper.isAdmitted());
        simpleObject.put("canDeleteVisit", verifyIfUserHasPermissionToDeleteVisit(visit, authenticatedUser, canDeleteVisit));

        AppContextModel contextModel = sessionContext.generateAppContextModel();
        contextModel.put("patientId", visit.getPatient().getPatientId());
        contextModel.put("patientDead", visit.getPatient().isDead());
        contextModel.put("visit", new VisitContextModel(new VisitDomainWrapper(visit, emrApiProperties)));

        List<Extension> visitActions = appFrameworkService.getExtensionsForCurrentUser("patientDashboard.visitActions", contextModel);
        Collections.sort(visitActions);
        simpleObject.put("availableVisitActions", convertVisitActionsToSimpleObject(visitActions));

        return simpleObject;
    }

    private List<String> convertVisitActionsToSimpleObject(List<Extension> visitActions) {

        // just convert to a list of ids as strings
        List<String> visitActionsSimple = new ArrayList<String>();

        for (Extension visitAction : visitActions) {
            visitActionsSimple.add(visitAction.getId());
        }

        return visitActionsSimple;
    }

    private boolean verifyIfUserHasPermissionToDeleteVisit(Visit visit, User authenticatedUser, boolean canDeleteVisit) {
        VisitDomainWrapper visitDomainWrapper = new VisitDomainWrapper(visit);
        if ( visitDomainWrapper.hasEncounters() ){
            // allowed to delete only empty visits
            return false;
        }
        boolean userParticipatedInVisit = visitDomainWrapper.verifyIfUserIsTheCreatorOfVisit(authenticatedUser);
        return canDeleteVisit || userParticipatedInVisit;
    }

    public SimpleObject getEncounterDetails(@RequestParam("encounterId") Encounter encounter,
                                            @SpringBean("emrApiProperties") EmrApiProperties emrApiProperties,
                                            @SpringBean("locationService") LocationService locationService,
                                            @SpringBean("dispositionService") DispositionService dispositionService,
                                            UiUtils uiUtils) {

        ParserEncounterIntoSimpleObjects parserEncounter = new ParserEncounterIntoSimpleObjects(encounter, uiUtils,
                emrApiProperties, locationService, dispositionService);

        ParsedObs parsedObs = parserEncounter.parseObservations(uiUtils.getLocale());
        List<SimpleObject> orders = parserEncounter.parseOrders();

        return SimpleObject.create("observations", parsedObs.getObs(), "orders", orders, "diagnoses",
                parsedObs.getDiagnoses(), "dispositions", parsedObs.getDispositions());
    }

    public FragmentActionResult deleteEncounter(UiUtils ui,
                                                @SpringBean("featureToggles") FeatureToggleProperties featureToggleProperties,
                                                @RequestParam("encounterId") Encounter encounter,
                                                @SpringBean("encounterService") EncounterService encounterService,
                                                UiSessionContext sessionContext) {

        if (encounter != null) {
            User authenticatedUser = sessionContext.getCurrentUser();
            boolean canDelete = authenticatedUser.hasPrivilege(EmrApiConstants.PRIVILEGE_DELETE_ENCOUNTER);
            if (verifyIfUserHasPermissionToDeleteAnEncounter(encounter, authenticatedUser, canDelete)) {
                encounterService.voidEncounter(encounter, "delete encounter");
                encounterService.saveEncounter(encounter);
            } else {
                return new FailureResult(ui.message("OpenmrsLite.patientDashBoard.deleteEncounter.notAllowed"));
            }
        }
        return new SuccessResult(ui.message("OpenmrsLite.patientDashBoard.deleteEncounter.successMessage"));
    }

    public FragmentActionResult deleteVisit(UiUtils ui,
                                                @RequestParam("visitId") Visit visit,
                                                @SpringBean("visitService") VisitService visitService,
                                                UiSessionContext sessionContext) {

        if (visit != null ) {
            User authenticatedUser = sessionContext.getCurrentUser();
            boolean canDeleteVisit = authenticatedUser.hasPrivilege(EmrApiConstants.PRIVILEGE_DELETE_VISIT);
            if (verifyIfUserHasPermissionToDeleteVisit(visit, authenticatedUser, canDeleteVisit)) {
                visitService.voidVisit(visit, "delete visit");
                visitService.saveVisit(visit);
            } else {
                return new FailureResult(ui.message("emr.patientDashBoard.deleteVisit.notAllowed"));
            }
        }
        return new SuccessResult(ui.message("OpenmrsLite.task.deleteVisit.successMessage"));
    }

	public FragmentActionResult endVisit(UiUtils ui,
											@RequestParam("visitId") Visit visit,
											@SpringBean("visitService") VisitService visitService,
											UiSessionContext sessionContext) {
		User currentUser = sessionContext.getCurrentUser();
		if (currentUser == null || !currentUser.hasPrivilege(OpenmrsLiteConstants.PRIVILEGE_END_VISIT)) {
			return new FailureResult(ui.message("OpenmrsLite.task.endVisit.notAllowed"));
		}

		if (visit != null ) {
			try {
				visitService.endVisit(visit, new Date());
			} catch (APIAuthenticationException e) {
				return new FailureResult(ui.message("OpenmrsLite.task.endVisit.notAllowed"));
			}
		}
		return new SuccessResult(ui.message("OpenmrsLite.task.endVisit.successMessage"));
	}

    private boolean verifyIfUserHasPermissionToDeleteAnEncounter(Encounter encounter, User authenticatedUser,
                                                                   boolean canDelete) {
        EncounterDomainWrapper encounterDomainWrapper = new EncounterDomainWrapper(encounter);
        boolean userParticipatedInEncounter = encounterDomainWrapper.participatedInEncounter(authenticatedUser);
        return canDelete || userParticipatedInEncounter;
    }


}
