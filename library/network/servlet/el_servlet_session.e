note
	description: "Summary description for {HTTP_USER_SESSION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-10 18:29:16 GMT (Monday 10th June 2013)"
	revision: "3"

deferred class
	EL_SERVLET_SESSION

inherit
	EL_MODULE_LOG

	EL_MODULE_STRING

feature {NONE} -- Initialization

	make
		do
			log.enter ("make")
			create function_table.make (functions)
			create http_result.make_empty
			request := Default_request
			response := Default_response
			log.exit
		end

feature -- Basic operations

	service (a_request : GOA_HTTP_SERVLET_REQUEST; a_response : GOA_HTTP_SERVLET_RESPONSE)
		--
		require
			empty_http_result: http_result.is_empty
		local
			function: STRING
		do
			request := a_request
			response := a_response
			function := get_parameter (Function_parameter_name)
			if function.is_empty then
				http_result := "No function parameter found"
			else
				function_table.search (function)
				if function_table.found then
					function_table.found_item.apply
				else
					http_result := String.template ("No function %"$S%" found.").substituted (<< function >>)
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

	get_parameter (name: STRING): STRING
		do
			create Result.make_empty
			if request.has_parameter (name) then
				Result := request.get_parameter (name)
			end
		end

	send_cookie (name, value: STRING)
		do
			response.add_cookie (create {GOA_COOKIE}.make (name, value))
		end

	set_http_result (a_http_result: like http_result)
		do
			http_result := a_http_result
		end

	functions: ARRAY [TUPLE [STRING, like Type_service_procedure]]
		deferred
		end

	Type_service_procedure: PROCEDURE [EL_SERVLET_SESSION, TUPLE]
		do
		end

	function_table: EVOLICITY_OBJECT_TABLE [like Type_service_procedure]

	request : GOA_HTTP_SERVLET_REQUEST

	response : GOA_HTTP_SERVLET_RESPONSE

feature {NONE} -- Constants

	Function_parameter_name: STRING = "function"

	Default_request: GOA_CGI_SERVLET_REQUEST
		once
			create Result.make (Default_response)
		end

	Default_response: GOA_CGI_SERVLET_RESPONSE
		once
			create Result.make
		end

end
