note
	description: "Summary description for {HTTP_USER_SESSION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-10-03 10:36:28 GMT (Friday 3rd October 2014)"
	revision: "5"

deferred class
	EL_SERVLET_SESSION [G -> EL_SERVLET_CONFIG]

inherit
	EL_MODULE_LOG

	EL_MODULE_STRING

feature {NONE} -- Initialization

	make (a_config: like config)
		do
			log.enter ("make")
			config := a_config
			create function_table.make (functions)
			create http_result.make_empty
			request := Default_request
			response := Default_response
			log.exit
		end

feature -- Basic operations

	service (a_request: like request; a_response: like response)
		--
		require
			empty_http_result: http_result.is_empty
		local
			function: STRING
		do
			request := a_request; response := a_response
			function := a_request.parameter (Parameter_function_name)
			if function.is_empty then
				http_result := "No function parameter found"
			else
				function_table.search (function)
				if function_table.found then
					function_table.found_item.apply
				else
					http_result := String.template ("No function %"$S%" found.") #$ [function]
				end
			end
			response.set_content_length (http_result.count)
			response.send (http_result)
			http_result.wipe_out
			request := Default_request
			response := Default_response
		end

feature -- Access

	http_result: STRING

feature {NONE} -- Implementation

	set_http_result (a_http_result: like http_result)
		do
			http_result := a_http_result
		end

	functions: ARRAY [TUPLE [STRING, like Type_service_procedure]]
		deferred
		end

	Type_service_procedure: PROCEDURE [like Current, TUPLE]
		do
		end

	function_table: EVOLICITY_OBJECT_TABLE [like Type_service_procedure]

	request : EL_HTTP_SERVLET_REQUEST

	response : EL_HTTP_SERVLET_RESPONSE

	config: G

feature {NONE} -- Constants

	Parameter_function_name: STRING = "fn"

	Default_request: EL_HTTP_SERVLET_REQUEST
		once
			create Result
		end

	Default_response: EL_HTTP_SERVLET_RESPONSE
		once
			create Result
		end

end
