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

<script type="text/javascript" defer>
<%
  ui.includeJavascript("uicommons", "jquery-1.8.3.min.js", Integer.MAX_VALUE)
  ui.includeJavascript("uicommons", "jquery-ui-1.9.2.custom.min.js", Integer.MAX_VALUE)
  ui.includeJavascript("uicommons", "emr.js", Integer.MAX_VALUE - 15)
  ui.includeJavascript("uicommons", "knockout-2.1.0.js", Integer.MAX_VALUE - 15)
  ui.includeJavascript("uicommons", "underscore-min.js", Integer.MAX_VALUE - 10)
  // toastmessage plugin: https://github.com/akquinet/jquery-toastmessage-plugin/wiki
 ui.includeJavascript("uicommons", "jquery.toastmessage.js", Integer.MAX_VALUE - 20)
     
 // simplemodal plugin: http://www.ericmmartin.com/projects/simplemodal/
   ui.includeJavascript("uicommons", "jquery.simplemodal.1.4.4.min.js", Integer.MAX_VALUE - 20)
%>
</script>
