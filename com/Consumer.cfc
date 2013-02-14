<!--- Consumer.cfc

	Implements OAuth Spec 1.0 Revision A. Should work with any service provider,
	that implements this scheme. This is the application singleton. Generates and
	sends requests and redirects to the service provider
	
	Author: Stuie Wakefield
	Created: 2010-03-29
	
	License:-
	
	Copyright (c) 2010 Stuart/Stuie Wakefield

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	
	Contributors:
	
		Stuie Wakefield
	
--->

<cfcomponent 
	output="false">

	<cfset variables.consumerKey = ""/>
	<cfset variables.consumerSecret = ""/>
	<cfset variables.serviceProviderRealm = ""/>
	<cfset variables.version = "1.0"/>
	
	<cfset variables.encoder = CreateObject( "component", "Encoder" )/>

	<cffunction name="init" 
				output="false">
		<cfargument name="consumerKey" type="string"/>
		<cfargument name="consumerSecret" type="string"/>
		<cfif StructKeyExists( arguments, "consumerKey" )>
			<cfset setConsumerKey( arguments.consumerKey )/>
		</cfif>
		<cfif StructKeyExists( arguments, "consumerSecret" )>
			<cfset setConsumerSecret( arguments.consumerSecret )/>
		</cfif>
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="setConsumerKey" returntype="void"
				output="false">
		<cfargument name="consumerKey" type="string"
					required="true"/>
		<cfset variables.consumerKey = arguments.consumerKey/>
	</cffunction>
	<cffunction name="getConsumerKey" returntype="string"
				output="false">
		<cfreturn variables.consumerKey/>
	</cffunction>

	<cffunction name="setConsumerSecret" returntype="void"
				output="false">
		<cfargument name="consumerSecret" type="string"
					required="true"/>
		<cfset variables.consumerSecret = arguments.consumerSecret/>
	</cffunction>
	<cffunction name="getConsumerSecret" returntype="string"
				output="false">
		<cfreturn variables.consumerSecret/>
	</cffunction>
	
	<cffunction name="setServiceProviderRealm" returntype="void"
				output="false">
		<cfargument name="serviceProviderRealm" type="string"
					required="true"/>
		<cfset variables.serviceProviderRealm = arguments.serviceProviderRealm/>
	</cffunction>
	<cffunction name="getServiceProviderRealm" returntype="string"
				output="false">
		<cfreturn variables.serviceProviderRealm/>
	</cffunction>
	
	<cffunction name="setSigner" returntype="void"
				output="false">
		<cfargument name="signer" type="Signer"
					required="true"/>
		<cfset variables.signer = arguments.signer/>
		<cfset variables.signer.setConsumer( this )/>
	</cffunction>
	<cffunction name="getSigner" returntype="Signer"
				output="false">
		<cfreturn variables.signer/>
	</cffunction>
	
	<cffunction name="setOAuthVersion" returntype="void"
				output="false">
		<cfargument name="version" type="string"
					required="true"/>
		<cfset variables.version = arguments.version/>
	</cffunction>
	<cffunction name="getOAuthVersion" returntype="string"
				output="false">
		<cfreturn variables.version/>
	</cffunction>
	
	<cffunction name="createRequest" returntype="Request"
				output="false">
		<cfargument name="token" type="string"/>
		<cfargument name="tokenSecret" type="string"/>
		<cfset var req = CreateObject( "component", "Request" )>
		<cfreturn req.init( argumentCollection = arguments )/>
	</cffunction>
	
	<cffunction name="sendRequest" returntype="any"
				output="false">
		<cfargument name="req" type="Request"
					required="true"/>
		<cfset var parameter = false/>
		<cfset generateHeaders( arguments.req )/>
		<cfset getSigner( ).signRequest( arguments.req )/>
		<cfhttp url="#arguments.req.getRequestUrl( )#" method="#arguments.req.getMethod( )#">
			<cfhttpparam type="header" name="Authorization" value="OAuth #variables.encoder.headerEncodedParameterString( arguments.req.getHeaderParameters( ) )#"/>
			<cfloop array="#arguments.req.getParameters( )#" index="parameter">
				<cfhttpparam type="#arguments.req.getParameterType( )#" name="#variables.encoder.parameterEncodedFormat( parameter.name )#" value="#variables.encoder.parameterEncodedFormat( parameter.value )#"/>
			</cfloop>
		</cfhttp>
		<cfreturn cfhttp.fileContent/>			
	</cffunction>
	
	<cffunction name="authorizeRedirect" returntype="any"
				output="false">
		<cfargument name="req" type="Request"
					required="true"/>
		<cfset arguments.req.setMethod( "GET" )/>
		<cfset generateHeaders( arguments.req )/>
		<cfset getSigner( ).signRequest( arguments.req )/>
		<cflocation url="#arguments.req.getRequestURL( )#?#variables.encoder.urlEncodedParameterString( arguments.req.getAllParameters( ) )#" addtoken="false"/>		
	</cffunction>
	
	<cffunction name="generateHeaders" returntype="void">
		<cfargument name="req" type="Request"
					required="true"/>
		<cfset arguments.req.addHeaderParameter( "oauth_consumer_key", getConsumerKey( ) )/>
		<cfset arguments.req.addHeaderParameter( "oauth_nonce", generateNonce( ) )/>
		<cfset arguments.req.addHeaderParameter( "oauth_timestamp", generateTimeStamp( ) )/>
		<cfset arguments.req.addHeaderParameter( "oauth_signature_method", getSigner( ).name )/>
		<cfset arguments.req.addHeaderParameter( "oauth_version", getOAuthVersion( ) )/>
		<cfif Len( arguments.req.getOAuthToken( ) )>
			<cfset arguments.req.addHeaderParameter( "oauth_token", arguments.req.getOAuthToken( ) )/>
		</cfif>
	</cffunction>
	<cffunction name="generateNonce" returntype="string"
				output="false">
		<cfreturn CreateObject( "java", "java.lang.System" ).nanoTime( )/>
	</cffunction>
	<cffunction name="generateTimeStamp" returntype="string"
				output="false">
		<cfreturn DateDiff( "s", DateConvert( "utc2Local", "January 1 1970 00:00" ), Now( ) )/>
	</cffunction>

</cfcomponent>