note
	description: "Summary description for {HTTP_USER_SESSION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-30 12:42:25 GMT (Monday 30th October 2017)"
	revision: "3"

deferred class
	EL_SERVLET_SESSION [G -> EL_SERVLET_SERVICE_CONFIG]

inherit
	EL_MODULE_LOG

	EL_HTTP_CONTENT_TYPE_CONSTANTS

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
			a_request.parameters.search (Parameter_function_name)
			if a_request.parameters.found then
				function := a_request.parameters.found_item
				function_table.search (function)
				if function_table.found then
					function_table.found_item.apply
				else
					http_result := No_function_found_template #$ [function]
				end
			else
				http_result := "No function parameter found"
			end
			response.set_content_length (http_result.count)
			response.set_content (http_result, Content_plain_latin_1)
			http_result.wipe_out
			request := Default_request
			response := Default_response
		end

feature -- Access

	http_result: ZSTRING

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

	function_table: EL_ZSTRING_HASH_TABLE [like Type_service_procedure]

	request : FCGI_SERVLET_REQUEST

	response : FCGI_SERVLET_RESPONSE

	config: G

feature {NONE} -- Constants

	Parameter_function_name: STRING = "fn"

	Default_request: FCGI_SERVLET_REQUEST
		once
			create Result.make (Default_internal_request, Default_response)
		end

	Default_internal_request: FCGI_REQUEST
		once
			create Result.make
		end

	Default_response: FCGI_SERVLET_RESPONSE
		once
			create Result.make (Default_internal_request)
		end

	No_function_found_template: ZSTRING
		once
			Result := "No function %"%S%" found."
		end

end
