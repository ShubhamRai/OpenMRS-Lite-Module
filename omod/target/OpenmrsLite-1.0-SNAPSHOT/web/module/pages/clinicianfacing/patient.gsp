<%
    ui.decorateWith("appui", "standardEmrPage")
%>
<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.format(patient.patient.familyName) }, ${ ui.format(patient.patient.givenName) }" ,
        link: '${ui.pageLink("OpenmrsLite", "clinicianfacing/clinicianFacingPatientDashboard", [patientId: patient.patient.id])}'}
    ]
    var patient = { id: ${ patient.id } };
</script>

<% if(includeFragments){
    includeFragments.each{ %>
        ${ ui.includeFragment(it.extensionParams.provider, it.extensionParams.fragment)}
<%   }
} %>

${ ui.includeFragment("OpenmrsLite", "patientHeader", [ patient: patient.patient, activeVisit: activeVisit ]) }

<div class="clear"></div>
<div class="container">
    <div class="dashboard clear">
        <div class="info-container column">
            ${ ui.includeFragment("OpenmrsLite", "clinicianfacing/diagnosisWidget", [ patient: patient ]) }

            ${ ui.includeFragment("OpenmrsLite", "vitals/mostRecentVitals", [patientId: patient.patient.id]) }
        </div>
        <div class="info-container column">
            <%/*
            <div class="info-section">
                <div class="info-header">
                    <i class="icon-medicine"></i>
                    <h3>${ ui.message("OpenmrsLite.clinicianfacing.prescribedMedication").toUpperCase() }</h3>
                </div>
                <div class="info-body">
                    <ul>
                        <li></li>
                    </ul>
                    <a class="view-more">${ ui.message("OpenmrsLite.clinicianfacing.showMoreInfo") } ></a>
                </div>
            </div>
            <div class="info-section">
                <div class="info-header">
                    <i class="icon-medical"></i>
                    <h3>${ ui.message("OpenmrsLite.clinicianfacing.allergies").toUpperCase() }</h3>
                </div>
                <div class="info-body">
                    <ul>
                        <li></li>
                    </ul>
                </div>
            </div>
            */%>
            ${ ui.includeFragment("OpenmrsLite", "clinicianfacing/visitsSection", [patient: patient]) }
        </div>
        <div class="action-container column">
            <div class="action-section">
                <% if (activeVisit) {
                    def contextModel = [ patientId: patient.id, "visit.id": activeVisit.visitId, "visit.active": true, "visit.admitted": activeVisit.admitted ]
                %>
                    <ul>
                        <h3>${ ui.message("OpenmrsLite.clinicianfacing.activeVisitActions") }</h3>
                        <% visitActions.each { ext -> %>
                            <li>
                                <a href="${ ui.escapeJs(ext.url("/" + ui.contextPath(), contextModel, ui.thisUrl())) }" id="${ ext.id }">
                                    <i class="${ ext.icon }"></i>
                                    ${ ui.message(ext.label) }
                                </a>
                            </li>
                        <% } %>
                    </ul>
                <% } %>
                <ul>
                    <h3>${ ui.message("OpenmrsLite.clinicianfacing.overallActions") }</h3>
                    <%
                        def contextModel = [ patientId: patient.id ]
                        overallActions.each { ext -> %>
                            <a href="${ ui.escapeJs(ext.url("/" + ui.contextPath(), contextModel, ui.thisUrl())) }" id="${ ext.id }">
                                <li>
                                    <i class="${ ext.icon }"></i>
                                    ${ ui.message(ext.label) }
                                </li>
                            </a>
                    <% } %>
                </ul>
                <%
                 def cxtModel = [ patientId: patient.id, activeVisitId: activeVisit ? activeVisit.visit.id : null]
                 otherActions.each { action -> %>
                <a id="${ action.id }" class="button medium" href="${ ui.escapeJs(action.url("/" + ui.contextPath(), cxtModel)) }">
                    <i class="${ action.icon }"></i>${ ui.message(action.label) }
                </a>
                <% } %>
            </div>
        </div>
    </div>
</div>
