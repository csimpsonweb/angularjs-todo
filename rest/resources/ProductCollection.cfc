<cfcomponent extends="taffy.core.resource" taffy:uri="/tasks">

	<!--- PUBLIC METHODS --->

	<cffunction name="get">
		<cfquery name="local.tasks">
			SELECT *
			FROM tasks
		</cfquery>

		<cfset local.tasks = querytoarray(local.tasks)>

		<cfreturn representationOf(local.tasks)>
	</cffunction>

</cfcomponent>
