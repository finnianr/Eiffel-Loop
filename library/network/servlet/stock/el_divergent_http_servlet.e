note
	description: "[
		Experimental servlet with service procedure that distributes requests to procedures in
		service_procedures_table according to the request path base name, i.e. the last directory 
		step: request.dir_path.base 
		 		
		Works best if the web server URL matching rule is a regular expression.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-13 11:29:25 GMT (Monday 13th November 2017)"
	revision: "4"

deferred class
	EL_DIVERGENT_HTTP_SERVLET

inherit
	FCGI_HTTP_SERVLET
		redefine
			make
		end

feature {NONE} -- Initialization

	make (a_servlet_config: like servlet_config)
		do
			Precursor (a_servlet_config)
			service_procedures := service_procedures_table
			procedure_names := service_procedures.current_keys
		end

feature -- Access

	procedure_names: like service_procedures.current_keys

feature {NONE} -- Implementation

	serve (request: like new_request; response: like new_response)
		do
			service_procedures.search (request.dir_path.base)
			if service_procedures.found then
				service_procedures.found_item.call ([request, response])
			else
				lio.put_string_field (Message_invalid_path, request.dir_path.to_string)
				lio.put_new_line
				response.set_content (Message_invalid_path, Content_plain_utf_8)
			end
		end

	serve_nothing (request: like new_request; response: like new_response)
			-- Useful for closing down a servlet thread by requesting this response from the main thread
			-- using CURL. Add this agent to service_procedures_table.
		do
			response.set_content_ok
		end

	service_procedures: EL_ZSTRING_HASH_TABLE [PROCEDURE [FCGI_SERVLET_REQUEST, FCGI_SERVLET_RESPONSE]]

	service_procedures_table: like service_procedures
		deferred
		end

feature {NONE} -- Constants

	Message_invalid_path: STRING = "Page not found"

end
