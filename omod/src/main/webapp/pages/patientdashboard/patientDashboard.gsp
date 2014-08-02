<%
    ui.decorateWith("OpenmrsLite", "standardEmrPage")

    ui.includeCss("OpenmrsLite", "patientdashboard/patientDashboard.css")

    ui.includeJavascript("uicommons", "bootstrap-collapse.js")
    ui.includeJavascript("uicommons", "bootstrap-transition.js")


    def tabs = [
        [ id: "visits", label: ui.message("OpenmrsLite.patientDashBoard.visits"), provider: "OpenmrsLite", fragment: "patientdashboard/visits" ],
        patientTabs.collect{
            [id: it.id, label: ui.message(it.label), provider: it.extensionParams.provider, fragment: it.extensionParams.fragment]
        }
    ]

    if (!isNewPatientHeaderEnabled) {
      tabs.add([ id: "contactInfo", label: ui.message("OpenmrsLite.patientDashBoard.contactinfo"), provider: "OpenmrsLite", fragment: "patientdashboard/contactInfo" ])
    }
    tabs = tabs.flatten()

	if(!returnUrl) {
		returnUrl = ui.pageLink("OpenmrsLite", "patientdashboard/patientDashboard", [patientId: patient.patient.id])
	}

%>
<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.format(patient.patient.familyName) }, ${ ui.format(patient.patient.givenName) }" , link: '${ui.escapeJs(returnUrl)}'}
    ];

    jq(function(){
        jq(".tabs").tabs();
    });

    var patient = { id: ${ patient.id } };
</script>

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


<% if (sessionContext.currentUser.hasPrivilege(privilegePatientDashboard)
        || (!featureToggles.isFeatureEnabled("newPatientSearchWidget"))) { %>
<!-- as a sanity check, don't allow users without find patient privilege to view patient dashboard -->

    <% if(includeFragments){
        includeFragments.each{ %>
            ${ ui.includeFragment(it.extensionParams.provider, it.extensionParams.fragment)}
    <%   }
    } %>

    ${ ui.includeFragment("OpenmrsLite", "patientHeader", [ patient: patient.patient, activeVisit: activeVisit ]) }
    <div class="actions dropdown">
        <span class="dropdown-name"><i class="icon-cog"></i>${ ui.message("OpenmrsLite.actions") }<i class="icon-sort-down"></i></span>
        <ul>
            <% overallActions.each {
                def url = it.url
                url = it.url(contextPath, actionBindings, ui.thisUrl())
            %>
                <li>
                    <a href="${ url }"><i class="${ it.icon }"></i>${ ui.message(it.label) }</a>
                </li>
            <% } %>
        </ul>
    </div>

    <div class="tabs" xmlns="http://www.w3.org/1999/html">
        <div class="dashboard-container">

            <ul>
                <% tabs.each { %>
                <li>
                    <a href="#${ it.id }">
                        ${ it.label }
                    </a>
                </li>
                <% } %>

            </ul>

            <% tabs.each { %>
            <div id="${it.id}">
                ${ ui.includeFragment(it.provider, it.fragment, [ patient: patient ]) }
            </div>
            <% } %>

        </div>
    </div>

<% } else { %>

    <div>
        <span class="error">${ ui.message('OpenmrsLite.patientDashBoard.noAccess') }</span>
    </div>

<% } %>
