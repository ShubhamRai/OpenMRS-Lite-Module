<%

    def htmlSafeId = { extension ->
        "${ extension.id.replace(".", "-") }-${ extension.id.replace(".", "-") }-extension"
    }
%>

<div id="home-container">

	<h1>${ui.message("OpenmrsLite.home.heading")}</h1>

    <% if (authenticatedUser) { %>
        <h4>
            ${ ui.message("OpenmrsLite.home.currentUser", ui.format(authenticatedUser), ui.format(sessionContext.sessionLocation)) }
        </h4>
    <% } else { %>
        <h4>
            <a href="login.htm">${ ui.message("OpenmrsLite.home.logIn") }</a>
        </h4>
    <% } %>

    <div id="apps">
        <% extensions.each { ext -> %>
            <a id="${ htmlSafeId(ext) }" href="/${ contextPath }/${ ext.url }" class="button app big">
                <% if (ext.icon) { %>
                   <i class="${ ext.icon }"></i>
                <% } %>
                ${ ui.message(ext.label) }
            </a>
        <% } %>
    </div>

</div>
