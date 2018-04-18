note
	description: "Fast-CGI servlet request"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-10 10:48:50 GMT (Tuesday 10th April 2018)"
	revision: "7"

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

	parameters: like broker.parameters
		do
			Result := broker.parameters
		end

	method_parameters: EL_URL_QUERY_HASH_TABLE
		-- non-duplicate http parameters from either the GET-data (URI query string)
		-- or POST-data (`raw_stdin_content')
		do
			Result := parameters.method_parameters
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

	value_integer (name: ZSTRING): INTEGER
		do
			Result := value_string (name).to_integer_32
		end

	value_natural_8 (name: ZSTRING): NATURAL_8
		do
			Result := value_string (name).to_natural_8
		end

	value_natural (name: ZSTRING): NATURAL
		do
			Result := value_string (name).to_natural_32
		end

	value_string (name: ZSTRING): ZSTRING
		local
			table: like method_parameters
		do
			table := method_parameters
			table.search (name)
			if table.found then
				Result := table.found_item
			else
				create Result.make_empty
			end
		end

	value_string_8 (name: ZSTRING): STRING
		do
			Result := value_string (name)
		end

feature -- Status query

	has_parameter (name: ZSTRING): BOOLEAN
			-- Does this request have a parameter named 'name'?
		do
			Result := method_parameters.has (name)
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

end
