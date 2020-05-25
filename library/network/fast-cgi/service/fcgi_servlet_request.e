note
	description: "Fast-CGI servlet request"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-24 11:10:16 GMT (Sunday 24th May 2020)"
	revision: "10"

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
			broker := a_response.broker
			headers := parameters.headers
		end

feature -- Access

	dir_path: EL_DIR_PATH
		do
			Result := relative_path_info
		end

	headers: FCGI_HTTP_HEADERS

	method_parameters: EL_URI_QUERY_ZSTRING_HASH_TABLE
		-- non-duplicate http parameters from either the GET-data (URI query string)
		-- or POST-data (`raw_stdin_content')
		do
			Result := parameters.method_parameters
		end

	parameters: like broker.parameters
		do
			Result := broker.parameters
		end

	relative_path_info: ZSTRING
		do
			Result := broker.relative_path_info
		end

	remote_address: ZSTRING
		do
			Result := parameters.remote_addr
		end

	remote_address_32: NATURAL
		do
			Result := parameters.remote_address_32
		end

	servlet_path: STRING
			-- The part of this request's URL that calls the servlet. This includes
			-- either the servlet name or a path to the servlet, but does not include
			-- any extra path information or a query string.
		do
			Result := parameters.script_name
		end

	value_integer (name: READABLE_STRING_GENERAL): INTEGER
		do
			Result := value_string (name).to_integer_32
		end

	value_natural (name: READABLE_STRING_GENERAL): NATURAL
		do
			Result := value_string (name).to_natural_32
		end

	value_natural_8 (name: READABLE_STRING_GENERAL): NATURAL_8
		do
			Result := value_string (name).to_natural_8
		end

	value_string (name: READABLE_STRING_GENERAL): ZSTRING
		local
			table: like method_parameters
		do
			table := method_parameters
			table.search (General.to_zstring (name))
			if table.found then
				Result := table.found_item
			else
				create Result.make_empty
			end
		end

	value_string_8 (name: READABLE_STRING_GENERAL): STRING
		do
			Result := value_string (name)
		end

feature -- Status query

	has_parameter (name: READABLE_STRING_GENERAL): BOOLEAN
			-- Does this request have a parameter named 'name'?
		do
			Result := method_parameters.has (General.to_zstring (name))
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

	broker: FCGI_REQUEST_BROKER
		-- Internal request information and stream functionality.

	internal_response: FCGI_SERVLET_RESPONSE
		-- Response object held so that session cookie can be set.

	servlet: FCGI_HTTP_SERVLET

feature {NONE} -- Constants

	General: EL_ZSTRING_CONVERTER
		once
			create Result.make
		end

end
