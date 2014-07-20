<%
	ui.decorateWith("OpenmrsLite", "patientSearchPage")
 %>

<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.message(label)}"}
    ];

    jq(function() {
        jq('#patient-search').focus();
    });

</script>

<h2>
	${ ui.message(heading) }
</h2>

${ ui.includeFragment("OpenmrsLite", "patientsearch/patientSearchWidget",
        [ afterSelectedUrl: afterSelectedUrl,
          showLastViewedPatients: showLastViewedPatients ])}
