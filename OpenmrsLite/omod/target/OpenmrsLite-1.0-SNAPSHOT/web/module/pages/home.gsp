<%
      ui.decorateWith("appui", "standardEmrPage", [ title: ui.message("OpenmrsLite.home.title") ])
  
      def htmlSafeId = { extension ->
         "${ extension.id.replace(".", "-") }-${ extension.id.replace(".", "-") }-extension"
        }
%>


<div id="home-container">

	<h1>${ui.message("OpenmrsLite.home.heading")}</h1>

    <% if (context.authenticated) { %>
        <h4>
            ${ ui.message("OpenmrsLite.home.currentUser", ui.format(context.authenticatedUser), ui.format(sessionContext.sessionLocation)) }
        </h4>
    <% } else { %>
        <h4>
            <a href="login.htm">${ ui.message("OpenmrsLite.home.logIn") }</a>
        </h4>
    <% } %>

    <div id="apps">
    </div>

</div>
