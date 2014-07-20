<div class="info-section most-recent-encounter">
    <div class="info-header">
        <i class="icon-vitals"></i>
        <h3>${ ui.message("OpenmrsLite.clinicianfacing.vitals").toUpperCase() }</h3>
    </div>
    <div class="info-body">

        <div id="most-recent-vitals-container" class="in collapse">
            ${ ui.message(encounter ? "uicommons.loading.placeholder" : "OpenmrsLite.clinicianfacing.noneRecorded") }
        </div>

        <% if (encounter) { %>
            <script type="text/javascript">
                emr.getFragmentActionWithCallback("htmlformentryui", "htmlform/viewEncounterWithHtmlForm", "getAsHtml", { encounterId: ${encounter.id} }, function(result) {
                    jq('#most-recent-vitals-container').html(result.html);
                    jq('.collapse .title').text('${ ui.escapeJs(ui.message("OpenmrsLite.clinicianfacing.lastVitalsDateLabel", ui.formatDatetimePretty(encounter.encounterDatetime))) } ');
                });
            </script>
        <% } %>
    </div>
</div>
