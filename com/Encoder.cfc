<!--- Encoder.cfc

	Encodes and serializes parameter arrays. Parameter arrays are stored as an
	array of structs including a name and value, as it is feasible in this scheme
	to include multiple parameters with the same identifier. Serializes parameters
	according to header parameter spec and url parameter spec.
	
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

	<cffunction name="parameterEncodedFormat" returntype="string">
		<cfargument name="str" type="string"
					required="true"/>
		<cfset var encoded = URLEncodedFormat( arguments.str )/>
		<cfset encoded = Replace( encoded, "%5F", "_", "ALL" )/>
		<cfset encoded = Replace( encoded, "%2E", ".", "ALL" )/>
		<cfset encoded = Replace( encoded, "%2D", "-", "ALL" )/>
		<cfset encoded = Replace( encoded, "%7E", "~", "ALL" )/>
		<cfreturn encoded/>
	</cffunction>
	
	<cffunction name="headerEncodedParameterArray" returntype="array"
				output="false">
		<cfargument name="parameterArray" type="array"
					required="true"/>
		<cfset var encoded = []/>
		<cfset var encodedName = false/>
		<cfset var encodedValue = false/>
		<cfloop array="#arguments.parameterArray#" index="param">
			<cfset encodedName = parameterEncodedFormat( param.name )/>
			<cfset encodedValue = parameterEncodedFormat( param.value )/>
			<cfset ArrayAppend( encoded, '#encodedName#="#encodedValue#"' )/>
		</cfloop>
		<cfreturn encoded/>
	</cffunction>
	
	<cffunction name="headerEncodedParameterString" returntype="string"
				output="false">
		<cfargument name="parameterArray" type="array"
					required="true"/>
		<cfset var encoded = headerEncodedParameterArray( arguments.parameterArray )/>
		<cfreturn ArrayToList( encoded, ", " )/>
	</cffunction>
	
	<cffunction name="urlEncodedParameterArray" returntype="array"
				output="false">
		<cfargument name="parameterArray" type="array"
					required="true"/>
		<cfset var encoded = []/>
		<cfset var encodedName = false/>
		<cfset var encodedValue = false/>
		<cfloop array="#arguments.parameterArray#" index="param">
			<cfset encodedName = parameterEncodedFormat( param.name )/>
			<cfset encodedValue = parameterEncodedFormat( param.value )/>
			<cfset ArrayAppend( encoded, "#encodedName#=#encodedValue#" )/>
		</cfloop>
		<cfreturn encoded/>
	</cffunction>
	
	<cffunction name="urlEncodedParameterString" returntype="string"
				output="false">
		<cfargument name="parameterArray" type="array"
					required="true"/>
		<cfset var encoded = urlEncodedParameterArray( arguments.parameterArray )/>
		<cfreturn ArrayToList( encoded, "&" )/>
	</cffunction>

</cfcomponent>