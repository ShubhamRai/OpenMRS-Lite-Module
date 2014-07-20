<%
    ui.decorateWith("appui", "standardEmrPage")
%>

<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.message("OpenmrsLite.deletedPatient.breadcrumbLabel") }" }
    ];
</script>

<h1>${ ui.message("OpenmrsLite.deletedPatient.title") }</h1>

<p>${ ui.message("OpenmrsLite.deletedPatient.description") }</p>
