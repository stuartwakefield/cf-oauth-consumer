<!--- Request.cfc

	Represents a service request to the service provider can represent a protected
	or public resource request. Used to encapsulate request attributes to pass
	to the consumer to fulfil.
	
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

	<cfset variables.requestURL = ""/>
	<cfset variables.method = "GET"/>
	<cfset variables.parameters = []/>
	<cfset variables.headerParameters = []/>
	<cfset variables.token = ""/>
	<cfset variables.tokenSecret = ""/>

	<cffunction name="init" 
				output="false">
		<cfargument name="token" type="string"/>
		<cfargument name="tokenSecret" type="string"/>
		<cfif StructKeyExists( arguments, "token" )>
			<cfset setOAuthToken( arguments.token )/>
		</cfif>
		<cfif StructKeyExists( arguments, "tokenSecret" )>
			<cfset setOAuthTokenSecret( arguments.tokenSecret )/>
		</cfif>		
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="setRequestURL" returntype="void"
				output="false">
		<cfargument name="requestURL" type="string"
					required="true"/>
		<cfset variables.requestURL = arguments.requestURL/>
	</cffunction>
	<cffunction name="getRequestURL" returntype="string"
				output="false">
		<cfreturn variables.requestURL/>
	</cffunction>
	
	<cffunction name="setMethod" returntype="void"
				output="false">
		<cfargument name="method" type="string"
					required="true"/>
		<cfset variables.method = arguments.method/>
	</cffunction>
	<cffunction name="getMethod" returntype="string"
				output="false">
		<cfreturn variables.method/>
	</cffunction>
	<cffunction name="getParameterType" returntype="string"
				output="false">
		<cfset var parameterType = "URL"/>
		<cfif CompareNoCase( getMethod( ), "get" ) neq 0>
			<cfset parameterType = "FORMFIELD"/>
		</cfif>
		<cfreturn parameterType/>
	</cffunction>
	
	<cffunction name="setOAuthToken" returntype="void"
				output="false">
		<cfargument name="token" type="string"
					required="true"/>
		<cfset variables.token = arguments.token/>
	</cffunction>
	<cffunction name="getOAuthToken" returntype="string"
				output="false">
		<cfreturn variables.token/>
	</cffunction>
	
	<cffunction name="setOAuthTokenSecret" returntype="void"
				output="false">
		<cfargument name="tokenSecret" type="string"
					required="true"/>
		<cfset variables.tokenSecret = arguments.tokenSecret/>
	</cffunction>
	<cffunction name="getOAuthTokenSecret" returntype="string"
				output="false">
		<cfreturn variables.tokenSecret/>
	</cffunction>

	<cffunction name="addParameter" returntype="void"
				output="false">
		<cfargument name="name" type="string"
					required="true"/>
		<cfargument name="value" type="string"
					required="true"/>
		<cfset var param = { name = arguments.name, value = arguments.value }/>
		<cfset ArrayAppend( variables.parameters, param )/>
	</cffunction>
	<cffunction name="removeParameter" returntype="void"
				output="false">
		<cfargument name="name" type="string"
					required="true"/>
		<cfargument name="value" type="string"
					required="true"/>
		<cfset var param = false/>
		<cfset var parameters = []/>
		<cfloop array="#variables.parameters#" index="param">
			<cfif Compare( param.name, arguments.name ) neq 0>
				<cfset ArrayAppend( parameters, param )/>
			</cfif>
		</cfloop>
		<cfset variables.parameters = parameters/>
	</cffunction>
	<cffunction name="clearParameters" returntype="void"
				output="false">
		<cfset variables.parameters = []/>		
	</cffunction>
	<cffunction name="getParameters" returntype="array"
				output="false">
		<cfreturn variables.parameters/>
	</cffunction>
	
	<cffunction name="addHeaderParameter" returntype="void"
				output="false">
		<cfargument name="name" type="string"
					required="true"/>
		<cfargument name="value" type="string"
					required="true"/>
		<cfset var param = { name = arguments.name, value = arguments.value }/>
		<cfset ArrayAppend( variables.headerParameters, param )/>
	</cffunction>
	<cffunction name="removeHeaderParameter" returntype="void"
				output="false">
		<cfargument name="name" type="string"
					required="true"/>
		<cfargument name="value" type="string"
					required="true"/>
		<cfset var param = false/>
		<cfset var parameters = []/>
		<cfloop array="#variables.headerParameters#" index="param">
			<cfif Compare( param.name, arguments.name ) neq 0>
				<cfset ArrayAppend( parameters, param )/>
			</cfif>
		</cfloop>
		<cfset variables.headerParameters = parameters/>
	</cffunction>
	<cffunction name="clearHeaderParameters" returntype="void"
				output="false">
		<cfset variables.headerParameters = []/>		
	</cffunction>
	<cffunction name="getHeaderParameters" returntype="array"
				output="false">
		<cfreturn variables.headerParameters/>
	</cffunction>
	
	<cffunction name="getAllParameters" returntype="array"
				output="false">
		<cfset var param = false/>
		<cfset var parameters = Duplicate( variables.parameters )/>
		<cfloop array="#variables.headerParameters#" index="param">
			<cfset ArrayAppend( parameters, param )/>
		</cfloop>
		<cfreturn parameters/>
	</cffunction>

</cfcomponent>