<div class="contact-info-inline">
    <span>
        ${ ui.format(config.patient.personAddress).replace("\n", ", ")}
        <em>${ ui.message("OpenmrsLite.person.address")}</em>
    </span>
    <span class="left-margin">
        ${config.patient.telephoneNumber ?: ''}
        <em>${ ui.message("OpenmrsLite.person.telephoneNumber")}</em>
    </span>
    <% if(!config.hideEditDemographicsButton) { %>
    <small class="left-margin">
        <a href="/${contextPath}/OpenmrsLite/editPatientContactInfo.page?patientId=${config.patient.patient.id}&appId=OpenmrsLite.OpenmrsLite.registerPatient&returnUrl=${ui.urlEncode(ui.thisUrl())}">${ui.message("general.edit")}</a>
    </small>
    <% } %>
</div>
