<%
      def htmlSafeId = { extension ->
         "${ extension.id.replace(".", "-") }-${ extension.id.replace(".", "-") }-extension"
        }
%>

<header>
    <div class="logo">
    	     <a href="${ui.pageLink("OpenmrsLite", "home")}">
	     <img src="${ui.resourceLink("OpenmrsLite", "images/openMrsLogo.png")}"/>
    </div>
</header>

<div id="home-container">

	<h4>${ui.message("OpenmrsLite.home.heading")}</h4>

    <% if (context.authenticated) { %>
        <h5>
            ${ ui.message("OpenmrsLite.home.currentUser", ui.format(context.authenticatedUser), ui.format(sessionContext.sessionLocation)) }
        </h5>
	<li class="logout">
	 	<a href="/${contextPath}/logout">
	         ${ui.message("emr.logout")}
	         </a>
	  </li>

    <% } else { %>
        <h5>
            <a href="login.htm">${ ui.message("OpenmrsLite.home.logIn") }</a>
        </h5>
    <% } %>



    <div id="apps">
    	 <% extensions.each { ext -> %>
		<p> <a id="${ htmlSafeId(ext) }" href="/${ contextPath }/${ ext.url }" class="button app big">
		 ${ ui.message(ext.label) }
		 </a>
		</p>
	<% } %>
    </div>

</div>
