<!--- HMACSHA1Signer.cfc

	Signs requests for verification by the service provider. Used by the service
	provider to determine authenticity of the request and prevent replay attacks.
	Uses the HMAC-SHA1 message authentication code algorithm.
	
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
	output="false" 
	extends="Signer">

	<cfset this.name = "HMAC-SHA1"/>

	<cffunction name="signRequest" returntype="void"
				output="false">
		<cfargument name="req" type="Request"
					required="true"/>
		<cfset var encoded = variables.encoder.urlEncodedParameterArray( arguments.req.getAllParameters( ) )/>
		<cfset var secretKey = "#getConsumer( ).getConsumerSecret( )#&#arguments.req.getOAuthTokenSecret( )#"/>
		<cfset var key = CreateObject( "java", "javax.crypto.spec.SecretKeySpec" ).init( secretKey.getBytes( ), "HmacSHA1" )/>
		<cfset var mac = CreateObject( "java", "javax.crypto.Mac" ).getInstance( key.getAlgorithm( ) )/>
		<cfset var baseString = "#variables.encoder.parameterEncodedFormat( UCase( arguments.req.getMethod( ) ) )#"/>
		<cfset baseString = "#baseString#&#variables.encoder.parameterEncodedFormat( LCase( arguments.req.getRequestURL( ) ) )#"/>
		<cfset ArraySort( encoded, "textnocase" )/>
		<cfset baseString = "#baseString#&#variables.encoder.parameterEncodedFormat( ArrayToList( encoded, "&" ) )#"/>
		<cfset mac.init( key )/>
		<cfset mac.update( baseString.getBytes( ) )/>
		<cfset arguments.req.addHeaderParameter( "oauth_signature", BinaryEncode( mac.doFinal( ), "base64" ) )/>
	</cffunction>

</cfcomponent>