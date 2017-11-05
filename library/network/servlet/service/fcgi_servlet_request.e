note
	description: "Summary description for {FCGI_SERVLET_REQUEST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-03 10:06:47 GMT (Friday 3rd November 2017)"
	revision: "1"

class
	FCGI_SERVLET_REQUEST

inherit
	EL_EVENT_LISTENER
		rename
			notify as on_end_request
		end

create
	make

feature {NONE} -- Initialisation

	make (a_servlet: like servlet; a_response: FCGI_SERVLET_RESPONSE)
			-- Create a new fast cgi servlet request wrapper for
			-- the request information contained in 'fcgi_request'
		do
			servlet := a_servlet; internal_response := a_response
			internal_request := a_response.internal_request

			headers := internal_request.parameters

			-- This does not allow duplicate parameters, original parameters does.
			parameters := headers.http_parameters
		end

feature -- Access

	dir_path: EL_DIR_PATH
		do
			Result := path_info
		end

	headers: like internal_request.parameters

	parameters: EL_HTTP_HASH_TABLE
		-- non-duplicate http parameters

	path_info: ZSTRING
		do
			Result := internal_request.path_info
		end

	remote_address: ZSTRING
		do
			Result := headers.remote_addr
		end

	remote_address_32: NATURAL
		do
			Result := headers.remote_address_32
		end

	servlet_path: STRING
			-- The part of this request's URL that calls the servlet. This includes
			-- either the servlet name or a path to the servlet, but does not include
			-- any extra path information or a query string.
		do
			Result := headers.script_name
		end

	value_integer (name: ZSTRING): INTEGER
		do
			Result := value_string (name).to_integer_32
		end

	value_natural (name: ZSTRING): NATURAL
		do
			Result := value_string (name).to_natural_32
		end

	value_string (name: ZSTRING): ZSTRING
		local
			l_parameters: like parameters
		do
			l_parameters := parameters
			l_parameters.search (name)
			if l_parameters.found then
				Result := l_parameters.found_item
			else
				create Result.make_empty
			end
		end

	value_string_8 (name: ZSTRING): STRING
		do
			Result := value_string (name).as_string_8
		end

feature -- Status query

	has_parameter (name: ZSTRING): BOOLEAN
			-- Does this request have a parameter named 'name'?
		do
			Result := parameters.has (name)
		end

feature -- Measurement

	content_length: INTEGER
			-- The length in bytes of the request body or -1 if the length is
			-- not known.
		do
			Result := headers.content_length
		end

feature {NONE} -- Event handling

	on_end_request
		do
			servlet.on_serve_done (Current)
		end

feature {NONE} -- Internal attributes

	internal_request: FCGI_REQUEST
		-- Internal request information and stream functionality.

	internal_response: FCGI_SERVLET_RESPONSE
		-- Response object held so that session cookie can be set.

	servlet: FCGI_HTTP_SERVLET

end
