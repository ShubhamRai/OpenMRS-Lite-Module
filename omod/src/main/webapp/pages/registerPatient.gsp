<%
    if (sessionContext.authenticated && !sessionContext.currentProvider) {
        throw new IllegalStateException("Logged-in user is not a Provider")
    }
    ui.includeJavascript("OpenmrsLite", "registerPatient.js");

    def genderOptions = [ [label: ui.message("emr.gender.M"), value: 'M'],
                          [label: ui.message("emr.gender.F"), value: 'F'] ]
%>
${ ui.includeFragment("uicommons", "validationMessages")}
${ ui.includeFragment("appui", "header") }


<script type="text/javascript">
    var breadcrumbs = [
        { icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm' },
        { label: "${ ui.message("OpenmrsLite.registration.label") }", link: "${ ui.pageLink("OpenmrsLite", "registerPatient") }" }
    ];

    var testFormStructure = "${formStructure}";
    
    var patientDashboardLink = '${ui.pageLink("OpenmrsLite", "clinicianfacing/patient")}';
    var getSimilarPatientsLink = '${ ui.actionLink("OpenmrsLite", "matchingPatients", "getSimilarPatients") }&appId=${appId}';
    
</script>

<div id="reviewSimilarPatients" class="dialog" style="display: none">
    <div class="dialog-header">
      <h3>${ ui.message("OpenmrsLite.reviewSimilarPatients")}</h3>
    </div>
    <div class="dialog-content">
        <p>
        	<em>${ ui.message("OpenmrsLite.selectSimilarPatient") }</em>
        </p>
        
        <ul id="similarPatientsSelect" class="select"></ul>
       
        <span class="button cancel"> ${ ui.message("OpenmrsLite.cancel") } </span>
    </div>
</div>

<div id="content" class="container">
    <h2>
        ${ ui.message("OpenmrsLite.registration.label") }
    </h2>

	<div id="similarPatients" class="highlighted" style="display: none;">
		   <div class="left" style="padding: 6px"><span id="similarPatientsCount"></span> ${ ui.message("OpenmrsLite.similarPatientsFound") }</div><button class="right" id="reviewSimilarPatientsButton">${ ui.message("OpenmrsLite.reviewSimilarPatients.button") }</button>
		   <div class="clear"></div>
	</div>
	

    <form class="simple-form-ui" id="registration" method="POST">
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
                            initialValue: initialNameFieldValue,
                            classes: [(name == "givenName" || name == "familyName") ? "required" : ""]
                    ])}

                <% } %>
                <input type="hidden" name="preferred" value="true"/>
            </fieldset>

            <fieldset id="demographics-gender">
                <legend id="genderLabel">${ ui.message("emr.gender") }</legend>
                <h3>${ui.message("OpenmrsLite.patient.gender.question")}</h3>
                ${ ui.includeFragment("uicommons", "field/radioButtons", [
                        label: "",
                        formFieldName: "gender",
                        maximumSize: 3,
                        options: genderOptions,
                        classes: ["required"],
                        initialValue: patient.gender
                ])}
            </fieldset>

            <fieldset class="multiple-input-date no-future-date date-required">
                <legend id="birthdateLabel">${ui.message("OpenmrsLite.patient.birthdate.label")}</legend>
                <h3>${ui.message("OpenmrsLite.patient.birthdate.question")}</h3>
                ${ ui.includeFragment("uicommons", "field/multipleInputDate", [
                        label: "",
                        formFieldName: "birthdate",
                        left: true,
                        showEstimated: true,
                        estimated: patient.birthdateEstimated,
                        initialValue: patient.birthdate
                  ])}
            </fieldset>

        </section>
        <!-- read configurable sections from the json config file-->
        <% formStructure.sections.each { structure ->
            def section = structure.value
            def questions=section.questions
        %>
            <section id="${section.id}">
                <span id="${section.id}_label" class="title">${ui.message(section.label)}</span>
                    <% questions.each { question ->
                        def fields=question.fields
                    %>
                        <fieldset<% if(question.legend == "Person.address"){ %> class="requireOne"<% } %>>
                            <legend id="${question.id}">${ ui.message(question.legend)}</legend>
                            <% if(question.legend == "Person.address"){ %>
                                ${ui.includeFragment("uicommons", "fieldErrors", [fieldName: "personAddress"])}
                            <% } %>
                            <% fields.each { field ->
                                def configOptions = [
                                        label:ui.message(field.label),
                                        formFieldName: field.formFieldName,
                                        left: true,
                                        "classes": field.cssClasses
                                ]
                                if(field.type == 'personAddress'){
                                    configOptions.addressTemplate = addressTemplate
                                }
                            %>
                                ${ ui.includeFragment(field.fragmentRequest.providerName, field.fragmentRequest.fragmentId, configOptions)}
                            <% } %>
                        </fieldset>
                    <% } %>
            </section>
        <% } %>
        <div id="confirmation">
            <span id="confirmation_label" class="title">${ui.message("OpenmrsLite.patient.confirm.label")}</span>
            <div class="before-dataCanvas"></div>
            <div id="dataCanvas"></div>
            <div class="after-data-canvas"></div>
            <div id="confirmationQuestion">
                Confirm submission? <p style="display: inline"><input type="submit" class="submitButton confirm right" value="${ui.message("OpenmrsLite.patient.confirm.label")}" /></p><p style="display: inline"><input id="cancelSubmission" class="cancel" type="button" value="${ui.message("OpenmrsLite.cancel")}" /></p>
            </div>
        </div>
    </form>
</div>
