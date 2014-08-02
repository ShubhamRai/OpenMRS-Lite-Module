<%
    ui.decorateWith("OpenmrsLite", "standardEmrPage")
%>

<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.message("OpenmrsLite.deletedPatient.breadcrumbLabel") }" }
    ];
</script>

<h1>${ ui.message("OpenmrsLite.deletedPatient.title") }</h1>

<p>${ ui.message("OpenmrsLite.deletedPatient.description") }</p>
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

