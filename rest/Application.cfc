<cfcomponent extends="taffy.core.api">

	<cfset this.name = "angularjstodo">
	<cfset this.datasource = this.name>

	<cfset variables.framework = {
		reloadKey = "reload",
		reloadPassword = "password",
		reloadOnEveryRequest = TRUE
	}>

</cfcomponent>
