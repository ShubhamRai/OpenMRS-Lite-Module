<%

    def genderOptions = [ [label: ui.message("emr.gender.M"), value: 'M'],
            [label: ui.message("emr.gender.F"), value: 'F'] ]

	if (!returnUrl) {
		returnUrl = "/${contextPath}/OpenmrsLite/patientdashboard/patientDashboard.page?patientId=${patient.patientId}"
	}
%>
${ ui.includeFragment("uicommons", "validationMessages")}
${ ui.includeFragment("appui", "header") }


<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.format(patient.familyName) }, ${ ui.format(patient.givenName) }", link: "${returnUrl}"},
        { label: "${ ui.message("OpenmrsLite.editPatientDemographics.label") }", link: "${ ui.pageLink("OpenmrsLite", "editPatientDemographics") }" }
    ];
</script>

<div id="content" class="container">
    <h2>
        ${ ui.message("OpenmrsLite.editPatientDemographics.label") }
    </h2>

    <form class="simple-form-ui" method="POST">
		<input type="hidden" name="returnUrl" value="${returnUrl}" />
        <section id="demographics">
            <span class="title">${ui.message("OpenmrsLite.patient.demographics.label")}</span>

            <fieldset>
                <legend>${ui.message("OpenmrsLite.patient.name.label")}</legend>
                <h3>${ui.message("OpenmrsLite.patient.name.question")}</h3>
                <% nameTemplate.lineByLineFormat.each { name ->
                    def initialNameFieldValue = ""
                    if(patient.personName && patient.personName[name]){
                        initialNameFieldValue = patient.personName[name]
                    }
                %>
                ${ ui.includeFragment("OpenmrsLite", "field/personName", [
                        label: ui.message(nameTemplate.nameMappings[name]),
                        size: nameTemplate.sizeMappings[name],
                        formFieldName: name,
                        dataItems: 4,
                        left: true,
                        ignoreCheckForSimilarNames: true,
                        initialValue: initialNameFieldValue,
                        classes: [(name == "givenName" || name == "familyName") ? "required" : ""]
                ])}

                <% } %>
                <input type="hidden" name="preferred" value="true"/>
            </fieldset>

            <fieldset>
                <legend id="genderLabel">${ ui.message("emr.gender") }</legend>
                ${ ui.includeFragment("uicommons", "field/radioButtons", [
                        label: ui.message("OpenmrsLite.patient.gender.question"),
                        formFieldName: "gender",
                        maximumSize: 3,
                        options: genderOptions,
                        classes: ["required"],
                        initialValue: patient.gender
                ])}
            </fieldset>

            <fieldset class="multiple-input-date no-future-date">
                <legend>${ui.message("OpenmrsLite.patient.birthdate.label")}</legend>
                <h3>${ui.message("OpenmrsLite.patient.birthdate.question")}</h3>
                ${ ui.includeFragment("uicommons", "field/multipleInputDate", [
                        label: "",
                        formFieldName: "birthdate",
                        left: true,
                        classes: ["required"],
                        estimated: patient.birthdateEstimated,
                        initialValue: patient.birthdate
                ])}
            </fieldset>

        </section>

        <div id="confirmation">
            <span class="title">${ui.message("OpenmrsLite.patient.confirm.label")}</span>
            <div class="before-dataCanvas"></div>
            <div id="dataCanvas"></div>
            <div class="after-data-canvas"></div>
            <div id="confirmationQuestion">
                Confirm submission? <p style="display: inline"><input type="submit" class="confirm right" value="${ui.message("OpenmrsLite.patient.confirm.label")}" /></p><p style="display: inline"><input id="cancelSubmission" class="cancel" type="button" value="${ui.message("OpenmrsLite.cancel")}" /></p>
            </div>
        </div>
    </form>
</div>
