<%
	ui.includeJavascript("OpenmrsLite", "jquery-1.8.3.min.js", Integer.MAX_VALUE)
	ui.includeJavascript("OpenmrsLite", "jquery-ui-1.9.2.custom.min.js", Integer.MAX_VALUE)
        ui.includeJavascript("OpenmrsLite", "emr.js", Integer.MAX_VALUE - 15)
        ui.includeJavascript("OpenmrsLite", "knockout-2.1.0.js", Integer.MAX_VALUE - 15)
	ui.includeJavascript("OpenmrsLite", "underscore-min.js", Integer.MAX_VALUE - 10)
	
          
        // toastmessage plugin: https://github.com/akquinet/jquery-toastmessage-plugin/wiki
        ui.includeJavascript("OpenmrsLite", "jquery.toastmessage.js", Integer.MAX_VALUE - 20)
           
        // simplemodal plugin: http://www.ericmmartin.com/projects/simplemodal/
	ui.includeJavascript("OpenmrsLite", "jquery.simplemodal.1.4.4.min.js", Integer.MAX_VALUE - 20)

%>
