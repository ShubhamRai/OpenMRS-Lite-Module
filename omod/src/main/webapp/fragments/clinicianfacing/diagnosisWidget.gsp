<div class="info-section">
    <div class="info-header">
        <i class="icon-diagnosis"></i>
        <h3>${ ui.message("OpenmrsLite.clinicianfacing.diagnosis").toUpperCase() }</h3>
    </div>
    <div class="info-body">
		<% if (!config.recentDiagnoses) { %>
		${ ui.message("OpenmrsLite.none") }
		<% } else { %>
        <ul>
            <% config.recentDiagnoses.each { %>
            <li>
            <% if(it.diagnosis.nonCodedAnswer) { %>
                "${it.diagnosis.nonCodedAnswer}"
            <% } else { %>
                ${ui.format(it.diagnosis.codedAnswer)}
            <% } %>
            </li>
            <% } %>
        </ul>
		<% } %>
        <!-- <a class="view-more">${ ui.message("OpenmrsLite.clinicianfacing.showMoreInfo") } ></a> //-->
    </div>
</div>
