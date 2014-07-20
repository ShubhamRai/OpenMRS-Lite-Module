<%
    ui.includeJavascript("uicommons", "navigator/validators.js", Integer.MAX_VALUE - 19)

    def genderOptions = [ [label: ui.message("emr.gender.M"), value: 'M'],
            [label: ui.message("emr.gender.F"), value: 'F'] ]

    def monthOptions = [ [label: ui.message("OpenmrsLite.month.1"), value: 1],
            [label: ui.message("OpenmrsLite.month.2"), value: 2],
            [label: ui.message("OpenmrsLite.month.3"), value: 3],
            [label: ui.message("OpenmrsLite.month.4"), value: 4],
            [label: ui.message("OpenmrsLite.month.5"), value: 5],
            [label: ui.message("OpenmrsLite.month.6"), value: 6],
            [label: ui.message("OpenmrsLite.month.7"), value: 7],
            [label: ui.message("OpenmrsLite.month.8"), value: 8],
            [label: ui.message("OpenmrsLite.month.9"), value: 9],
            [label: ui.message("OpenmrsLite.month.10"), value: 10],
            [label: ui.message("OpenmrsLite.month.11"), value: 11],
            [label: ui.message("OpenmrsLite.month.12"), value: 12] ]

	if (!returnUrl) {
		returnUrl = "/${contextPath}/OpenmrsLite/patientdashboard/patientDashboard.page?patientId=${patient.patientId}"
	}
%>
${ ui.includeFragment("uicommons", "validationMessages")}


<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.format(patient.familyName) }, ${ ui.format(patient.givenName) }", link: "${returnUrl}" },
        { label: "${ ui.message("OpenmrsLite.editPatientContactInfo.label") }", link: "${ ui.pageLink("OpenmrsLite", "editPatientContactInfo") }" }
    ];
</script>

<div id="content" class="container">
    <h2>
        ${ ui.message("OpenmrsLite.editPatientContactInfo.label") }
    </h2>

    <form class="simple-form-ui" method="POST">
		<input type="hidden" name="returnUrl" value="${returnUrl}" />
        <!-- read configurable sections from the json config file-->
        <% formStructure.sections.each { structure ->
            def section = structure.value
            def questions=section.questions
        %>
        <section id="${section.id}">
            <span class="title">${ui.message(section.label)}</span>
            <% questions.each { question ->
                def fields=question.fields
            %>
            <fieldset>
                <legend>${ ui.message(question.legend)}</legend>
                <% fields.each { field ->
                    def configOptions = [
                            label:ui.message(field.label),
                            formFieldName: field.formFieldName,
                            left: true]
                    if(field.type == 'personAddress'){
                        configOptions.addressTemplate = addressTemplate
                        configOptions.initialValue = patient.personAddress;
                    }else if(field.type == 'personAttribute'){
                        configOptions.initialValue = uiUtils.getAttribute(patient, field.uuid);
                    }
                %>
                ${ ui.includeFragment(field.fragmentRequest.providerName, field.fragmentRequest.fragmentId, configOptions)}
                <% } %>
            </fieldset>
            <% } %>
        </section>
        <% } %>

        <div id="confirmation">
            <span class="title">${ui.message("OpenmrsLite.patient.confirm.label")}</span>
            <div class="before-dataCanvas"></div>
            <div id="dataCanvas"></div>
            <div class="after-data-canvas"></div>
            <div id="confirmationQuestion">
                ${ui.message("OpenmrsLite.confirm")} <p style="display: inline"><input type="submit" class="confirm" value="${ui.message("general.yes")}" /></p> or <p style="display: inline"><input id="cancelSubmission" class="cancel" type="button" value="${ui.message("general.no")}" /></p>
            </div>
        </div>
    </form>
</div>
