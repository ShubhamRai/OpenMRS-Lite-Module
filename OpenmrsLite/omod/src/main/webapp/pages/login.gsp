<%
    ui.includeFragment("appui", "standardEmrIncludes")
    ui.includeCss("OpenmrsLite", "login.css")
%>  


<!DOCTYPE html>
<html>
<head>
    <title>${ ui.message("OpenmrsLite.login.title") }</title>
    <link rel="shortcut icon" type="image/ico" href="/${ ui.contextPath() }/images/openmrs-favicon.ico"/>
    <link rel="icon" type="image/png\" href="/${ ui.contextPath() }/images/openmrs-favicon.png"/>
    ${ ui.resourceLinks() }
</head>
<body>
<script type="text/javascript">
    var OPENMRS_CONTEXT_PATH = '${ ui.contextPath() }';
</script>


<header>
    <div class="logo">
        <a href="${ui.pageLink("OpenmrsLite", "home")}">
	<img src="${ui.resourceLink("OpenmrsLite", "images/openMrsLogo.png")}",height="20" width="20"/>
	</a>
    </div>
</header>

<div id="body-wrapper">
    <div id="content">
        <form id="login-form" method="post" autocomplete="off">
            <fieldset>

                <legend>
                    <i class="icon-lock small"></i>
		    ${ ui.message("OpenmrsLite.login.loginHeading") }
                </legend>

                <p class="left">
                    <label for="username">
                        ${ ui.message("OpenmrsLite.login.username") }:
                    </label>
                    <input id="username" type="text" name="username" placeholder="${ ui.message("OpenmrsLite.login.username.placeholder") }"/>
                </p>

                <p class="left">
                    <label for="password">
                        ${ ui.message("OpenmrsLite.login.password") }:
                    </label>
                    <input id="password" type="password" name="password" placeholder="${ ui.message("OpenmrsLite.login.password.placeholder") }"/>
                </p>

                <p class="clear">
                    <label for="sessionLocation">
                        ${ ui.message("OpenmrsLite.login.sessionLocation") }:
                    </label>
                    <ul id="sessionLocation" class="select">
		    	<% locations.sort { ui.format(it) }.each { %>
	          	  <li id="${it.name}" value="${it.id}">${ui.format(it)}</li>
	           	  <% } %>
                    </ul>
                </p>


                <p></p>
                <p>
                    <input id="login-button" class="confirm" type="submit" value="${ ui.message("OpenmrsLite.login.button") }"/>
                </p>
                <p>
                    <a id="cant-login" href="javascript:void(0)">
                        <i class="icon-question-sign small"></i>
                        ${ ui.message("OpenmrsLite.login.cannotLogin") }
                    </a>
                </p>

            </fieldset>


        </form>

    </div>
</div>

<div id="cannot-login-popup" class="dialog" style="display: none">
    <div class="dialog-header">
        <i class="icon-info-sign"></i>
        <h3>${ ui.message("OpenmrsLite.login.cannotLogin") }</h3>
    </div>
    <div class="dialog-content">
        <p class="dialog-instructions">${ ui.message("OpenmrsLite.login.cannotLoginInstructions") }</p>

        <button class="confirm">${ ui.message("OpenmrsLite.okay") }</button>
    </div>
</div>

</body>
</html>
