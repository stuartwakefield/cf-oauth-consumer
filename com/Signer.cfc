<!--- Consumer.cfc

	Abstract signer class, specifies the signer interface and includes the encoder
	utility required when building a signature.
	
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

	<cfset variables.encoder = CreateObject( "component", "Encoder" )/>

	<cffunction name="setConsumer" returntype="void"
				output="false">
		<cfargument name="consumer" type="Consumer"
					required="true"/>
		<cfset variables.consumer = arguments.consumer/>
	</cffunction>
	<cffunction name="getConsumer" returntype="Consumer"
				output="false">
		<cfreturn variables.consumer/>
	</cffunction>

	<cffunction name="signRequest" returntype="void"
				output="false">
		<cfargument name="req" type="Request"
					required="true"/>

	</cffunction>

</cfcomponent>