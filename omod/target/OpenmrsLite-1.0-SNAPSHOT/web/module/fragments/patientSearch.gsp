<%
	sessionContext.requireAuthentication()

	ui.includeJavascript("uicommons", "jquery-1.8.3.min.js", Integer.MAX_VALUE)
	ui.includeJavascript("OpenmrsLite", "jquery-ui-1.9.2.custom.min.js.zip", Integer.MAX_VALUE - 10)
	ui.includeJavascript("uicommons", "underscore-min.js", Integer.MAX_VALUE - 10)
	ui.includeJavascript("uicommons", "knockout-2.1.0.js", Integer.MAX_VALUE - 15)
	ui.includeJavascript("uicommons", "emr.js", Integer.MAX_VALUE - 15)
	  
	ui.includeCss("uicommons", "styleguide/jquery-ui-1.9.2.custom.min.css", Integer.MAX_VALUE - 10)
	 
	// toastmessage plugin: https://github.com/akquinet/jquery-toastmessage-plugin/wiki
	ui.includeJavascript("uicommons", "jquery.toastmessage.js", Integer.MAX_VALUE - 20)
	ui.includeCss("uicommons", "styleguide/jquery.toastmessage.css", Integer.MAX_VALUE - 20)
	  
	// simplemodal plugin: http://www.ericmmartin.com/projects/simplemodal/
	ui.includeJavascript("uicommons", "jquery.simplemodal.1.4.4.min.js", Integer.MAX_VALUE - 20)
	  
	def title = config.title ?: ui.message("emr.title")
%>

<!DOCTYPE html>
<html>
    <head>
        <title>${ title ?: "OpenMRS" }</title>
        <link rel="shortcut icon" type="image/ico" href="/${ ui.contextPath() }/images/openmrs-favicon.ico"/>
        <link rel="icon" type="image/png\" href="/${ ui.contextPath() }/images/openmrs-favicon.png"/>
        ${ ui.resourceLinks() }
    </head>
    <body>
        <script type="text/javascript">
            var OPENMRS_CONTEXT_PATH = '${ ui.contextPath() }';
            window.translations = window.translations || {};
        </script>

${ ui.includeFragment("appui", "header") }

<div id="body-wrapper">

    ${ ui.includeFragment("uicommons", "infoAndErrorMessage") }

    <div id="content" class="container">
        <%= config.content %>
    </div>

</div>


<script type="text/javascript">

    // global error handler
    jq(document).ajaxError(function(event, jqxhr) {
        emr.redirectOnAuthenticationFailure(jqxhr);
    });

    var featureToggles = {};

    <% featureToggles.getToggleMap().each { %>
        featureToggles["${it.key}"] = ${ Boolean.parseBoolean(it.value)};
    <% } %>

</script>

</body>
</html>
