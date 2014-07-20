<%
    def patient = config.patient

    def dateFormat = new java.text.SimpleDateFormat("dd MMM yyyy hh:mm a")

    ui.includeCss("OpenmrsLite", "patientHeader.css")
    ui.includeJavascript("OpenmrsLite", "patientdashboard/patient.js")
%>


<script type="text/javascript">
    var addMessage = "${ ui.message("OpenmrsLite.patient.identifier.add") }";
    jq(document).ready(function () {
        createEditPatientIdentifierDialog(${patient.id});
        jq("#patientIdentifierValue").keyup(function(event){
            var oldValue = jq("#patientIdentifierValue").val();
            var newValue = jq("#hiddenInitialIdentifierValue").val();
            if(oldValue==newValue){
                jq('.confirm').attr("disabled", "disabled");
                jq('.confirm').addClass("disabled");
            }else{
                jq('.confirm').removeAttr("disabled");
                jq('.confirm').removeClass("disabled");
                if(event.keyCode == 13){
                    //ENTER key has been pressed
                    jq('#confirmIdentifierId').click();
                }
            }

        });

        jq(".editPatientIdentifier").click(function (event) {
            var identifierTypeId = jq(event.target).attr("data-identifier-type-id");
            var identifierTypeName = jq(event.target).attr("data-identifier-type-name");
            var patientIdentifierValue = jq(event.target).attr("data-patient-identifier-value");

            jq("#hiddenIdentifierTypeId").val(identifierTypeId);
            jq("#hiddenInitialIdentifierValue").val(patientIdentifierValue);
            jq("#identifierTypeNameSpan").text(identifierTypeName);
            jq("#patientIdentifierValue").val(patientIdentifierValue);

            showEditPatientIdentifierDialog();

            jq('.confirm').attr("disabled", "disabled");
            jq('.confirm').addClass("disabled");

        });

        jq(".demographics .name").click(function () {
            emr.navigateTo({
                provider: 'OpenmrsLite',
                page: 'patientdashboard/patientDashboard',
                query: { patientId: ${patient.patient.id} }
            });
        })

        <% if (config.isNewPatientHeaderEnabled) { %>
            jq("#patient-header-contactInfo").click(function (){
                var contactInfoDialogDiv = jq("#contactInfoContent");

                if (contactInfoDialogDiv.hasClass('hidden')) {
                    contactInfoDialogDiv.removeClass('hidden');
                    jq(this).addClass('expanded');
                } else {
                    contactInfoDialogDiv.addClass('hidden');
                    jq(this).removeClass('expanded');
                }

                return false;
            });
        <% } %>
    })
</script>

<div class="patient-header">

    <div class="demographics">
        <h1 class="name">
            <span>${ui.format(patient.patient.familyName)},<em>${ui.message("OpenmrsLite.patientHeader.familyname")}</em></span>
            <span>${ui.format(patient.patient.givenName)}<em>${ui.message("OpenmrsLite.patientHeader.givenname")}</em></span>
            &nbsp;
            <span class="gender-age">
                <span>${ui.message("OpenmrsLite.gender." + patient.gender)}&nbsp;</span>
                <span>
                <% if (patient.birthdate) { %>
                <% if (patient.age > 0) { %>
                    ${ui.message("OpenmrsLite.ageYears", patient.age)} 
                <% } else if (patient.ageInMonths > 0) { %>
                    ${ui.message("OpenmrsLite.ageMonths", patient.ageInMonths)}
                <% } else { %>
                    ${ui.message("OpenmrsLite.ageDays", patient.ageInDays)}
                <% } %>   
                (<% if (patient.birthdateEstimated) { %>~<% } %>${ ui.formatDatePretty(patient.birthdate) })          
                <% } else { %>
                    ${ui.message("OpenmrsLite.unknownAge")}
                <% } %>
                </span>
                <% if(!config.hideEditDemographicsButton) { %>
                    <span>
                        <small><a href="/${contextPath}/registrationapp/editPatientDemographics.page?patientId=${patient.patient.id}&returnUrl=${ui.urlEncode(ui.thisUrl())}">${ui.message("general.edit")}</a></small>
                    </span>
                <% } %>
                <% if (config.isNewPatientHeaderEnabled) { %>
                <a href="#" id="patient-header-contactInfo" class="contact-info-label">
                    <span class="show">${ui.message("OpenmrsLite.patientHeader.showcontactinfo")}</span>
                    <i class="toggle-icon icon-caret-down small"></i>
                    <span class="hide">${ui.message("OpenmrsLite.patientHeader.hidecontactinfo")}</span>
                    <i class="toggle-icon icon-caret-up small"></i>
                </a>
                <% } %>
            </span>
            <% if (config.isNewPatientHeaderEnabled) { %>
                <div class="hidden" id="contactInfoContent">
                    ${ ui.includeFragment("OpenmrsLite", "patientdashboard/contactInfoInline", [ patient: config.patient ]) }
                </div>
            <% } %>

        </h1>
        <% if (patient.patient.dead) { %>
            <div class="death-message">
                ${ui.message("OpenmrsLite.deadPatient", ui.format(patient.patient.deathDate))}
            </div>
        <% } %>
        <% if (config.activeVisit) { %>
            <% def visit = config.activeVisit.visit %>
            <% if (config.isNewPatientHeaderEnabled) { %>
                <div class="active-visit-started-at-message">
                    ${ui.message("OpenmrsLite.patientHeader.activeVisit.at", config.activeVisitStartDatetime)}
                </div>
                <% if (config.activeVisit.admitted) { %>
                    <div class="active-visit-message">
                        ${ui.message("OpenmrsLite.patientHeader.activeVisit.inpatient", ui.format(config.activeVisit.latestAdtEncounter.location))}
                    </div>
                <% } else { %>
                    <div class="active-visit-message">
                        ${ui.message("OpenmrsLite.patientHeader.activeVisit.outpatient")}
                    </div>
                <% } %>
            <% } else { %>
            <div class="status-container">
                <span class="status active"></span>
                ${ui.message("OpenmrsLite.activeVisit")}
            </div>
            <% } %>
        <% } %>
    </div>

    <div class="identifiers">
        <em>${ui.message("OpenmrsLite.patientHeader.patientId")}</em>
        <% patient.primaryIdentifiers.each { %>
        <span>${it.identifier}</span>
        <% } %>
        <br/>
        <% if (config.extraPatientIdentifierTypes) { %>
        <% config.extraPatientIdentifierTypes.each { %>
        <% def extraPatientIdentifier = patient.patient.getPatientIdentifier(it.patientIdentifierType) %>
        <% if (extraPatientIdentifier) { %>
            <em>${ui.format(it.patientIdentifierType)}</em>
            <% if (it.editable) { %>
                 <span><a class="editPatientIdentifier" data-identifier-type-id="${it.patientIdentifierType.id}" data-identifier-type-name="${ui.format(it.patientIdentifierType)}"
                    data-patient-identifier-value="${extraPatientIdentifier}" href="#${it.patientIdentifierType.id}">${extraPatientIdentifier}</a></span>
            <% } else {%>
                <span>${extraPatientIdentifier}</span>
            <% } %>
        <% } else if (it.editable) { %>
            <em>${ui.format(it.patientIdentifierType)}</em>
            <span class="add-id"><a class="editPatientIdentifier" data-identifier-type-id="${it.patientIdentifierType.id}"
            data-identifier-type-name="${ui.format(it.patientIdentifierType)}" data-patient-identifier-value=""
            href="#${it.patientIdentifierType.id}">${ui.message("OpenmrsLite.patient.identifier.add")}</a></span>
        <% } %>

        <br/>
        <% } %>
        <% } %>
    </div>

    <div class="unknown-patient" style= <%=(!patient.unknownPatient) ? "display:none" : ""%>>
        ${ui.message("OpenmrsLite.patient.temporaryRecord")} <br/>

        <form action="/${contextPath}/emr/mergePatients.page" method="get">
            <input type="hidden" name="isUnknownPatient" value="true"/>
            <input type="hidden" name="patient1" value="${patient.patient.id}"/>
            <input type="submit" id="merge-button"
                   value="${ui.message("OpenmrsLite.mergePatients.mergeIntoAnotherPatientRecord.button")}"/>
        </form>
    </div>

    <div class="close"></div>
</div>

<div id="edit-patient-identifier-dialog" class="dialog" style="display: none">
    <div class="dialog-header">
        <h3>${ui.message("OpenmrsLite.patientDashBoard.editPatientIdentifier.title")}</h3>
    </div>

    <div class="dialog-content">
        <input type="hidden" id="hiddenIdentifierTypeId" value=""/>
        <input type="hidden" id="hiddenInitialIdentifierValue" value=""/>
        <ul>
            <li class="info">
                <span>${ui.message("OpenmrsLite.patient")}</span>
                <h5>${ui.format(patient.patient)}</h5>
            </li>
            <li class="info">
                <span id="identifierTypeNameSpan"></span>
            </li>
            <li class="info">
                <input id="patientIdentifierValue" value=""/>
            </li>
        </ul>

        <button id="confirmIdentifierId" class="confirm right">${ui.message("OpenmrsLite.confirm")}</button>
        <button class="cancel">${ui.message("OpenmrsLite.cancel")}</button>
    </div>
</div>
