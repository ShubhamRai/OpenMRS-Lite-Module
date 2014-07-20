<%
    config.require("afterSelectedUrl")

    ui.includeJavascript("uicommons", "datatables/jquery.dataTables.min.js")
    ui.includeJavascript("OpenmrsLite", "patientsearch/patientSearchWidget.js")
    ui.includeJavascript("uicommons", "moment.min.js")
%>
<script type="text/javascript">

    var lastViewedPatients = [];
    <%  if (showLastViewedPatients) {
            lastViewedPatients.each { it -> %>
    lastViewedPatients.push({uuid:"${ it.uuid }",fullName:"${ it.personName.fullName }",gender:"${ it.gender }",
        age:"${ it.age ?: '' }", birthdate:"${ it.birthdate ? dateFormatter.format(it.birthdate) : '' }",
        birthdateEstimated: ${ it.birthdateEstimated }, identifier:"${ it.patientIdentifier.identifier }"});
    <%      }
        }%>

    jq(function() {
        var widgetConfig = {
            initialPatients : lastViewedPatients,
            minSearchCharacters: ${ config.minSearchCharacters ?: 3 },
            afterSelectedUrl: '${ ui.escapeJs(config.afterSelectedUrl) }',
            messages: {
                info: '${ ui.message("OpenmrsLite.search.info") }',
                first: '${ ui.message("OpenmrsLite.search.first") }',
                previous: '${ ui.message("OpenmrsLite.search.previous") }',
                next: '${ ui.message("OpenmrsLite.search.next") }',
                last: '${ ui.message("OpenmrsLite.search.last") }',
                noMatchesFound: '${ ui.message("OpenmrsLite.search.noMatchesFound") }',
                noData: '${ ui.message("OpenmrsLite.search.noData") }',
                recent: '${ ui.message("OpenmrsLite.search.label.recent") }',
                searchError: '${ ui.message("OpenmrsLite.search.error") }',
                identifierColHeader: '${ ui.message("OpenmrsLite.search.identifier") }',
                nameColHeader: '${ ui.message("OpenmrsLite.search.name") }',
                genderColHeader: '${ ui.message("OpenmrsLite.gender") }',
                ageColHeader: '${ ui.message("OpenmrsLite.age") }',
                birthdateColHeader: '${ ui.message("OpenmrsLite.birthdate") }'
            }
        };

        new PatientSearchWidget(widgetConfig);
    });
</script>

<form method="get" id="patient-search-form" onsubmit="return false">
    <input type="text" id="patient-search" placeholder="${ ui.message("OpenmrsLite.findPatient.search.placeholder") }" autocomplete="off"/><i id="patient-search-clear-button" class="icon-remove"></i>
</form>

<div id="patient-search-results"></div>
