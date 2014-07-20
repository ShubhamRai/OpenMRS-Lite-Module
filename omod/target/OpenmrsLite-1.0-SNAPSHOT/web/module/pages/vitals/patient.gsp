<%
    ui.decorateWith("appui", "standardEmrPage")
%>

<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.message("OpenmrsLite.app.capturevitals.title") }", link: "${ ui.pageLink("OpenmrsLite", "findpatient/findPatient", [app: "OpenmrsLite.vitals"]) }" },
        { label: "${ ui.format(patient.patient.familyName) }, ${ ui.format(patient.patient.givenName) }" , link: '${ui.pageLink("OpenmrsLite", "patientdashboard/patientDashboard", [patientId: patient.id])}'},
    ];
</script>

${ ui.includeFragment("OpenmrsLite", "patientHeader", [ patient: patient.patient ]) }

<script type="text/javascript">
    jq(function() {
        jq('#actions .cancel').click(function() {
            emr.navigateTo({
                provider: "OpenmrsLite",
                page: "findpatient/findPatient",
                query: {
                    app: "OpenmrsLite.vitals"
                }
            });
        });
        jq('#actions .confirm').click(function() {
            emr.navigateTo({
                provider: "htmlformentryui",
                page: "htmlform/enterHtmlFormWithSimpleUi",
                query: {
                    patientId: "${ patient.id }",
                    visitId: "${ visit?.id }",
                    definitionUiResource: "OpenmrsLite:htmlforms/vitals.xml",
                    returnUrl: "${ ui.escapeJs(ui.pageLink("OpenmrsLite", "findpatient/findPatient?app=OpenmrsLite.vitals")) }",
                    breadcrumbOverride: "${ ui.escapeJs(breadcrumbOverride) }"
                }
            });
        });
        jq('#actions button').first().focus();
    });
</script>
<style>
    #existing-encounters {
        margin-top: 2em;
    }
</style>

<% if (visit) { %>

    <div class="container half-width">

        <h1>${ ui.message("OpenmrsLite.vitals.confirmPatientQuestion") }</h1>

        <div id="actions">
            <button class="confirm big right">
                <i class="icon-arrow-right"></i>
                ${ ui.message("OpenmrsLite.vitals.confirm.yes") }
            </button>

            <button class="cancel big">
                <i class="icon-arrow-left"></i>
                ${ ui.message("OpenmrsLite.vitals.confirm.no") }
            </button>
        </div>

        <div id="existing-encounters">
            <h3>${ ui.message("OpenmrsLite.vitals.vitalsThisVisit") }</h3>
            <table>
                <thead>
                    <tr>
                        <th>${ ui.message("OpenmrsLite.vitals.when") }</th>
                        <th>${ ui.message("OpenmrsLite.vitals.where") }</th>
                        <th>${ ui.message("OpenmrsLite.vitals.enteredBy") }</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (existingEncounters.size() == 0) { %>
                        <tr>
                            <td colspan="3">${ ui.message("emr.none") }</td>
                        </tr>
                    <% } %>
                    <% existingEncounters.each { enc ->
                        def minutesAgo = (long) ((System.currentTimeMillis() - enc.encounterDatetime.time) / 1000 / 60)
                    %>
                        <tr>
                            <td>${ ui.message("OpenmrsLite.vitals.minutesAgo", minutesAgo) }</td>
                            <td>${ ui.format(enc.location) }</td>
                            <td>${ ui.format(enc.creator) }</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

<% } else { %>

    <h1>
        ${ ui.message("OpenmrsLite.vitals.noVisit") }
    </h1>

    <div id="actions">
        <button class="cancel big">
            <i class="icon-arrow-left"></i>
            ${ ui.message("OpenmrsLite.vitals.noVisit.findAnotherPatient") }
        </button>
    </div>

<% } %>
