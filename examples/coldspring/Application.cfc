<cfcomponent output="false">

	<cfset this.name = "OAuthConsumer-ColdSpringExample"/>
	<cfset this.sessionManagement = true/>
	<cfset this.mappings[ "/oauth" ] = ExpandPath( "../../" )/>
	
	<cffunction name="onApplicationStart" returntype="boolean"
				output="false">
		<cfargument name="scope" type="struct"
					default="#application#"/>
		<cfset var app = arguments.scope/>
		<cfset var config = {}/>
		<cfset config.coldspringProperties = {}/>
		<cfset config.coldspringProperties.twitterRealm = "http://api.twitter.com/"/>
		<cfset config.coldspringProperties.twitterConsumerKey = ""/>
		<cfset config.coldspringProperties.twitterConsumerSecret = ""/>
		
		<cfset app.beanFactory = CreateObject( "component", "ColdSpring.beans.DefaultXmlBeanFactory" )/>
		<cfset app.beanFactory.init( defaultProperties = config.coldspringProperties )/>
		<cfset app.beanFactory.loadBeans( ExpandPath( "coldspring.xml" ) )/>
		
		<cfreturn true/>
	</cffunction>

</cfcomponent>