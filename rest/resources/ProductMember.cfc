<cfcomponent extends="taffy.core.resource" taffy:uri="/tasks/{id}">

	<!--- PUBLIC METHODS --->

	<cffunction name="get" returntype="any" output="false" hint="I get a task from the database">
		<cfargument name="id" type="numeric" required="true" hint="The task id">

		<cfquery name="local.task">
			SELECT *
			FROM tasks
			WHERE id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.id#">
		</cfquery>

		<cfif local.task.recordCount EQ 0>
			<cfreturn noData().withStatus(404, "Not Found")>
		</cfif>

		<cfset local.task = queryToArray(local.task)>

		<cfreturn representationOf(local.task)>
	</cffunction>

	<cffunction name="post" returntype="any" output="false" hint="I insert a task into the database">
		<cfargument name="id" type="any" required="false" hint="The task id">
		<cfargument name="description" type="any" required="false" hint="The task description">
		<cfargument name="done" type="any" required="false" hint="The task status">
		<cfargument name="due" type="any" required="false" hint="The task due date">

		<cfset local.validationResult = validatetask(argumentCollection = arguments)>
		<cfif arraylen(local.validationResult)>
			<cfreturn representationOf(local.validationResult).withStatus(400, "Invalid Data")>
		</cfif>

		<cfquery result="local.result">
			INSERT INTO tasks (
				description,
				done,
				due
			) VALUES (
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.description#">,
				<cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#arguments.done#">,
				<cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.due#">
			)
		</cfquery>

		<cfreturn representationOf(local.result.generatedKey)>
	</cffunction>

	<cffunction name="put" returntype="any" output="false" hint="I update a task in the database">
		<cfargument name="id" type="any" required="false" hint="The task id">
		<cfargument name="description" type="any" required="false" hint="The task description">
		<cfargument name="done" type="any" required="false" hint="The task status">
		<cfargument name="due" type="any" required="false" hint="The task due date">

		<cfset local.validationResult = validatetask(argumentCollection = arguments)>
		<cfif arraylen(local.validationResult)>
			<cfreturn representationOf(local.validationResult).withStatus(400, "Invalid Data")>
		</cfif>

		<cfif NOT (taskExists(id = arguments.id))>
			<cfreturn noData().withStatus(404, "Not Found")>
		</cfif>

		<cfquery>
			UPDATE tasks
			SET description = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#arguments.description#">,
				done = <cfqueryparam cfsqltype="CF_SQL_TINYINT" value="#arguments.done#">,
				due = <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.due#">
			WHERE id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.id#">
		</cfquery>

		<cfreturn representationOf(arguments.id)>
	</cffunction>

	<cffunction name="delete" returntype="any" output="false" hint="I delete a task from the database">
		<cfargument name="id" type="numeric" required="true" hint="The task id">

		<cfif NOT taskExists(id = arguments.id)>
			<cfreturn noData().withStatus(404, "Not Found")>
		</cfif>

		<cfquery>
			DELETE FROM tasks
			WHERE id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.id#">
		</cfquery>

		<cfreturn noData()>
	</cffunction>

	<!--- PRIVATE METHODS --->

	<cffunction name="taskExists" access="private" returntype="boolean" output="false" hint="I return true if the task exists">
		<cfargument name="id" type="numeric" required="true" hint="The task id">

		<cfquery name="local.checkTaskExists">
			SELECT count(id) AS countOfId
			FROM tasks
			WHERE id = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.id#">
		</cfquery>

		<cfreturn local.checkTaskExists.countOfId NEQ 0>
	</cffunction>

	<cffunction name="validateTask" access="private" returntype="array" output="false" hint="I validate a task">
		<cfargument name="id" type="any" required="false" hint="The task id">
		<cfargument name="description" type="any" required="false" hint="The task description">
		<cfargument name="done" type="any" required="false" hint="The task status">
		<cfargument name="due" type="any" required="false" hint="The task due date">

		<cfset local.errors = []>

		<cfif NOT structkeyexists(arguments, "id") OR NOT isnumeric(arguments.id)>
			<cfset arrayappend(local.errors, "id")>
		</cfif>
		<cfif NOT structkeyexists(arguments, "description") OR len(trim(arguments.description)) EQ 0>
			<cfset arrayappend(local.errors, "description")>
		</cfif>
		<cfif NOT structkeyexists(arguments, "due") OR NOT isdate(arguments.due)>
			<cfset arrayappend(local.errors, "due")>
		</cfif>

		<cfreturn local.errors>
	</cffunction>

</cfcomponent>
