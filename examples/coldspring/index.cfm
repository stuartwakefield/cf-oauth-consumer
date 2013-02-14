<!--- 
   -- Obviously you'll want to do some API error handling depending on the implementation of the service provider 
  --->

<!--- We have configured our application wide OAuth consumer already using coldspring --->
<cfset twitterConsumer = application.beanFactory.getBean( "TwitterConsumer" )/>

<!--- Start a brand new OAuth session if you want by calling index.cfm?new --->
<cfif StructKeyExists( url, "new" )>
	<cfset StructDelete( session, "twitterRequestToken" )/>
	<cfset StructDelete( session, "twitterRequestTokenSecret" )/>
	<cfset StructDelete( session, "twitterAccessToken" )/>
	<cfset StructDelete( session, "twitterAccessTokenSecret" )/>
</cfif>

<!--- Check to see if we have an access token, if so skip to the good part, otherwise get one --->
<cfif !StructKeyExists( session, "twitterAccessToken" )>

	<!--- Check to see if we have a request token as we do not have an access token --->
	<cfif !StructKeyExists( session, "twitterRequestToken" )>
	
		<!--- Create a request to get a request token for the OAuth service provider --->
		<cfset twitterRequest = twitterConsumer.createRequest()/>
		<cfset twitterRequest.setRequestURL( "http://api.twitter.com/oauth/request_token" )/>
		<cfset twitterResponse = twitterConsumer.sendRequest( twitterRequest )/>
		
		<!--- Grab the tokens from the response --->
		<cfset session.twitterRequestToken = REReplace( twitterResponse, ".*oauth_token=([^&]+).*", "\1", "ALL" )/>
		<cfset session.twitterRequestTokenSecret = REReplace( twitterResponse, ".*oauth_token_secret=([^&]+).*", "\1", "ALL" )/>
	
		<!--- Direct the end user to log in using the authorizeRedirect method to the service providers authorize endpoint --->
		<cfset twitterRequest = twitterConsumer.createRequest( session.twitterRequestToken, session.twitterRequestTokenSecret )/>
		<cfset twitterRequest.setRequestURL( "http://api.twitter.com/oauth/authorize" )/>
		<cfset twitterConsumer.authorizeRedirect( twitterRequest )/>
	
	<cfelse>
	
		<!--- We do have a request token so in that case get an access token --->
		<cfset twitterRequest = twitterConsumer.createRequest()/>
		<cfset twitterRequest.setRequestURL( "http://api.twitter.com/oauth/access_token" )/>
		<cfset twitterResponse = twitterConsumer.sendRequest( twitterRequest )/>
	
		<!--- Grab the tokens from the response --->
		<cfset session.twitterAccessToken = REReplace( twitterResponse, ".*oauth_token=([^&]+).*", "\1", "ALL" )/>
		<cfset session.twitterAccessTokenSecret = REReplace( twitterResponse, ".*oauth_token_secret=([^&]+).*", "\1", "ALL" )/>
		
		<!--- Just stick a cflocation here to shoot us back to the opening cfif --->
		<cflocation url="index.cfm" addtoken="false"/>
		
	</cfif>

<!--- Use the service providers API --->
<cfelse>

	<cfset twitterRequest = twitterConsumer.createRequest()/>
	<cfset twitterRequest.setRequestURL( "http://api.twitter.com/1/account/verify.json" )/>
	<cfset twitterRequest.addParameter( "screen_name", "stubertbear" )/>
	<cfset twitterResponse = twitterConsumer.sendRequest( twitterRequest )/>
	
	<cfdump var="#DeserializeJSON( twitterResponse.toString( ) )#"/>

</cfif>
