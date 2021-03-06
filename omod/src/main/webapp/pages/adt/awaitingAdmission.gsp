<%
    ui.decorateWith("appui", "standardEmrPage")
    ui.includeCss("OpenmrsLite", "adt/awaitingAdmission.css")
%>
<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.message("OpenmrsLite.app.awaitingAdmission.label")}"}
    ];

    var supportsAdmissionLocationTag = '${supportsAdmissionLocationTag}';
    var supportsLoginLocationTag = '${supportsLoginLocationTag}';

    // TODO: probably want replace the whole thing with either ngGrid or the new datatable widget
    // TODO: make this more robust--kind of hacky to rely on column index now that it can change
    var admitToLocationColumnIndex = ${ paperRecordIdentifierDefinitionAvailable ? '5' : '4' };
    var currentLocationColumnIndex = ${ paperRecordIdentifierDefinitionAvailable ? '3' : '2' };

    jq(document).ready(function() {

        var supportsSessionStorage = typeof(Storage) !== "undefined";

        // these variables are updated in the change handler and referenced in the filter added in afnFiltering
        var admitToLocationFilter;
        var currentLocationFilter;

        // see if we have values for this filters in session storage
        if(supportsSessionStorage) {
            var admitToLocationFilter = sessionStorage.getItem('org.openmrs.module.OpenmrsLite.adt.awaitingAdmission.admitToLocationFilter');
            var currentLocationFilter = sessionStorage.getItem('org.openmrs.module.OpenmrsLite.adt.awaitingAdmission.currentLocationFilter');

            if (admitToLocationFilter) {
                jq("#inpatients-filterByAdmitToLocation select option").each(function (element) {
                    if (jq(this).text().replace(/'/g, "\\’") === admitToLocationFilter) {
                        jq(this).attr('selected', true);
                    }
                });
            }
            if (currentLocationFilter) {
                jq("#inpatients-filterByCurrentLocation select option").each(function (element) {
                    if (jq(this).text().replace(/'/g, "\\’") === currentLocationFilter) {
                        jq(this).attr('selected', true);
                    }
                });
            }
        }

        // default the admit to location to the session location if no location in session storage
        if (!admitToLocationFilter) {
            admitToLocationFilter = jq("#inpatients-filterByAdmitToLocation select option:selected").text().replace(/'/g, "\\’");
        }

        // this whole hack-around is for the problem with filtering with elements that have a single quote
        // this adds filter that filters based on the current values of the admitToLocationFilter and currentLocationFilter variables
        // it is triggered when we call the fnDraw() method in the change event handlers below
        jq.fn.dataTableExt.afnFiltering.push(
                function (oSettings, aData, iDataIndex) {

                    // remove single quote
                    var admitToLocation = aData[admitToLocationColumnIndex].replace(/'/g, "\\’");

                    if (admitToLocationFilter) {
                        if (!admitToLocation.match(new RegExp(admitToLocationFilter))) {
                            return false;
                        }
                    }

                    var currentLocation = aData[currentLocationColumnIndex].replace(/'/g, "\\’");

                    if (currentLocationFilter) {
                        if (!currentLocation.match(new RegExp(currentLocationFilter))) {
                            return false;
                        }
                    }

                    return true;
                }
        );

        // update the admitToLocationFilter and redisplay table when that filter dropdown is changed
        jq("#inpatients-filterByAdmitToLocation").change(function(event){
            admitToLocationFilter = jq("#inpatients-filterByAdmitToLocation select option:selected").text().replace(/'/g, "\\’");
            if (supportsSessionStorage) {
                sessionStorage.setItem('org.openmrs.module.OpenmrsLite.adt.awaitingAdmission.admitToLocationFilter', admitToLocationFilter);
            }
            jq('#awaiting-admission').dataTable({ "bRetrieve": true }).fnDraw();
        });

        // update the currentLocationFilter and redisplay table when that filter dropdown is changed
        jq("#inpatients-filterByCurrentLocation").change(function(event){
            currentLocationFilter = jq("#inpatients-filterByCurrentLocation select option:selected").text().replace(/'/g, "\\’");
            if (supportsSessionStorage) {
                sessionStorage.setItem('org.openmrs.module.OpenmrsLite.adt.awaitingAdmission.currentLocationFilter', currentLocationFilter);
            }
            jq('#awaiting-admission').dataTable({ "bRetrieve": true }).fnDraw();
        });

    });

</script>

<h2>${ ui.message("OpenmrsLite.app.awaitingAdmission.title") }</h2>

<div class="inpatient-current-location-filter">
    ${ ui.includeFragment("uicommons", "field/location", [
            "id": "inpatients-filterByCurrentLocation",
            "formFieldName": "filterByCurentLocationId",
            "label": "OpenmrsLite.app.awaitingAdmission.filterByCurrent",
            "withTag": supportsLoginLocationTag
    ] ) }
</div>

<div class="inpatient-admitTo-location-filter">
    ${ ui.includeFragment("uicommons", "field/location", [
            "id": "inpatients-filterByAdmitToLocation",
            "formFieldName": "filterByAdmitToLocationId",
            "label": "OpenmrsLite.app.awaitingAdmission.filterByAdmittedTo",
            "withTag": supportsAdmissionLocationTag,
            "initialValue": sessionContext.sessionLocation
    ] ) }
</div>

<table id="awaiting-admission" width="100%" border="1" cellspacing="0" cellpadding="2">
    <thead>
    <tr>
        <th>${ ui.message("OpenmrsLite.patient.identifier") }</th>
        <% if (paperRecordIdentifierDefinitionAvailable) { %>
            <th>${ ui.message("paperrecord.archivesRoom.recordNumber.label") }</th>
        <% } %>
        <th>${ ui.message("OpenmrsLite.person.name") }</th>
        <th>${ ui.message("OpenmrsLite.app.awaitingAdmission.currentWard") }</th>
        <th>${ ui.message("OpenmrsLite.app.awaitingAdmission.provider") }</th>
        <th>${ ui.message("OpenmrsLite.app.awaitingAdmission.admissionLocation") }</th>
        <th>${ ui.message("OpenmrsLite.app.awaitingAdmission.diagnosis") }</th>
        <th>${ ui.message("OpenmrsLite.app.awaitingAdmission.admitPatient") }</th>

    </tr>
    </thead>
    <tbody>
    <% if ((awaitingAdmissionList == null) || (awaitingAdmissionList != null && awaitingAdmissionList.size() == 0)) { %>
    <tr>
        <td colspan="8">${ ui.message("OpenmrsLite.none") }</td>
    </tr>
    <% } %>
    <% awaitingAdmissionList.each { v ->
        def patientId = v.patientId
        def visitId = v.visitId
    %>
    <tr id="visit-${ v.patientId
    }">
        <td>${ v.primaryIdentifier ? ui.format(v.primaryIdentifier) : ''}</td>
        <% if (paperRecordIdentifierDefinitionAvailable) { %>
            <td>${ v.paperRecordIdentifier ? ui.format(v.paperRecordIdentifier) : ''}</td>
        <% } %>
        <td>
            <% if (sessionContext.currentUser.hasPrivilege(privilegePatientDashboard)
                    || (!featureToggles.isFeatureEnabled("newPatientSearchWidget"))) { %>
                <!-- only add link to patient dashboard if user has appropriate privilege -->
                <a href="${ ui.pageLink("OpenmrsLite", "patientdashboard/patientDashboard", [ patientId: v.patientId ]) }">
            <% } %>

            ${ ui.format((v.patientFirstName ? v.patientFirstName : '') + " " + (v.patientLastName ? v.patientLastName : '')) }

            <% if (sessionContext.currentUser.hasPrivilege(privilegePatientDashboard)
                    || (!featureToggles.isFeatureEnabled("newPatientSearchWidget"))) { %>
                </a>
            <% } %>
        </td>

        <td>
            ${ ui.format(v.mostRecentAdmissionRequestFromLocation) }
            <br/>
            <small>
                ${ ui.format(v.mostRecentAdmissionRequestDatetime)}
            </small>
        </td>
        <td>
            ${ ui.format(v.mostRecentAdmissionRequestProvider) }
        </td>
        <td>${ ui.format(v.mostRecentAdmissionRequestToLocation) }</td>
        <td>
            <% v.mostRecentAdmissionRequestDiagnoses.each { %>
                ${ ui.format(it.diagnosis.codedAnswer ?: it.diagnosis.nonCodedAnswer) }${ it != v.mostRecentAdmissionRequestDiagnoses.last() ? ', ' : '' }
            <% } %>
        </td>
        <td>
            <% admissionActions.each { task ->
                def url = task.url.replaceAll('\\{\\{patientId\\}\\}', patientId.toString())
                url = url.replaceAll('\\{\\{visit.id\\}\\}', visitId.toString())
            %>
            <p>
                <a href="/${ contextPath }/${ url }" class="">
                    <i class="${task.icon}"></i> ${ ui.message(task.label) }</a>
            </p>
            <% } %>
        </td>
    </tr>
    <% } %>
    </tbody>
</table>

<% if ( (awaitingAdmissionList != null) && (awaitingAdmissionList.size() > 0) ) { %>
${ ui.includeFragment("uicommons", "widget/dataTable", [ object: "#awaiting-admission",
        options: [
                bFilter: true,
                bJQueryUI: true,
                bLengthChange: false,
                iDisplayLength: 10,
                sPaginationType: '\"full_numbers\"',
                bSort: false,
                sDom: '\'ft<\"fg-toolbar ui-toolbar ui-corner-bl ui-corner-br ui-helper-clearfix datatables-info-and-pg \"ip>\''
        ]
]) }
<% } %>
