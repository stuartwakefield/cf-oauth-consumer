<cfcomponent output="false">

	<cfset this.name = "OAuthConsumer-BasicExample"/>
	<cfset this.sessionManagement = true/>
	<cfset this.mappings[ "/oauth" ] = ExpandPath( "../../" )/>
	
</cfcomponent>