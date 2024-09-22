note
	description: "[
		Experimental servlet with service procedure that distributes requests to procedures in
		service_procedures_table according to the request path base name, i.e. the last directory 
		step: request.dir_path.base 
		 		
		Works best if the web server URL matching rule is a regular expression.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 9:33:09 GMT (Sunday 22nd September 2024)"
	revision: "12"

deferred class
	EL_DIVERGENT_SERVLET

inherit
	FCGI_HTTP_SERVLET
		redefine
			make
		end

feature {NONE} -- Initialization

	make (a_service: like service)
		do
			Precursor (a_service)
			service_procedures := service_procedures_table
			procedure_names := service_procedures.key_list
		end

feature -- Access

	procedure_names: LIST [ZSTRING]

feature {NONE} -- Implementation

	serve
		do
			if service_procedures.has_key (request.dir_path.base) then
				service_procedures.found_item.call ([request, response])
			else
				lio.put_string_field (Message_invalid_path, request.dir_path.to_string)
				lio.put_new_line
				response.set_content (Message_invalid_path, Text_type.plain, {EL_ENCODING_TYPE}.UTF_8)
			end
		end

	serve_nothing
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