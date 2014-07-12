<%
    def recentVisits = config.recentVisits
    def patient = config.patient
%>
<div class="info-section">
    <div class="info-header">
        <i class="icon-calendar"></i>
        <h3>${ ui.message("OpenmrsLite.clinicianfacing.visits").toUpperCase() }</h3>
    </div>
    <div class="info-body">
        <% if (recentVisits.isEmpty()) { %>
        ${ui.message("OpenmrsLite.none")}
        <% } %>
        <ul>
            <% recentVisits.each{ %>
            <li class="clear">
                <a href="${ui.pageLink("OpenmrsLite", "patientdashboard/patientDashboard", [patientId: patient.patient.id, visitId: it.visitId])}#visits" class="visit-link">
                    ${ ui.formatDatePretty(it.startDatetime) }
                    <% if(it.stopDatetime && !it.startDatetime.format("yyyy/MM/dd").equals(it.stopDatetime.format("yyyy/MM/dd"))){ %> - ${ ui.formatDatePretty(it.stopDatetime) }<% } %>
                </a>
                <div class="tag">
                    <% if (it.stopDatetime == null || new Date().before(it.stopDatetime)) { %> ${ ui.message("OpenmrsLite.clinicianfacing.active") } - <% } %>
                    ${ (it.admissionEncounter) ? ui.message("OpenmrsLite.clinicianfacing.inpatient") : ui.message("OpenmrsLite.clinicianfacing.outpatient") }
                </div>
            </li>
            <% } %>
        </ul>
        <a class="view-more" href="${ui.pageLink("OpenmrsLite", "patientdashboard/patientDashboard", [patientId: patient.patient.id, returnUrl: ui.thisUrl()])}#visits">
            ${ ui.message("OpenmrsLite.clinicianfacing.showMoreInfo") } >
        </a>
    </div>
</div>
