note
	description: "Fast-CGI servlet request"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 17:14:33 GMT (Sunday 25th August 2024)"
	revision: "17"

class
	FCGI_SERVLET_REQUEST

inherit
	EL_EVENT_LISTENER
		rename
			notify as on_end_request
		end

	EL_LAZY_ATTRIBUTE
		rename
			item as method_parameters,
			new_item as new_method_parameters,
			actual_item as actual_method_parameters
		end

create
	make

feature {NONE} -- Initialisation

	make (a_servlet: like servlet)
			-- Create a new fast cgi servlet request wrapper for
			-- the request information contained in 'fcgi_request'
		do
			servlet := a_servlet
			broker := a_servlet.service.broker
			headers := parameters.headers
		end

feature -- Access

	dir_path: DIR_PATH
		do
			Result := relative_path_info
		end

	headers: FCGI_HTTP_HEADERS

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

	servlet_path: ZSTRING
			-- The part of this request's URL that calls the servlet. This includes
			-- either the servlet name or a path to the servlet, but does not include
			-- any extra path information or a query string.
		do
			Result := parameters.script_name
		end

feature -- Status query

	has_parameter (name: READABLE_STRING_GENERAL): BOOLEAN
		-- Does this request have a parameter with `name' ?
		do
			Result := method_parameters.has_general (name)
		end

feature -- Measurement

	content_length: INTEGER
		-- The length in bytes of the request body or -1 if the length is
		-- not known.
		do
			Result := headers.content_length
		end

feature -- Element change

	reset
		do
			actual_method_parameters := Void
		end

feature {NONE} -- Event handling

	on_end_request
		do
			servlet.on_serve_done
		end

feature {NONE} -- Implementation

	new_method_parameters: EL_URI_QUERY_ZSTRING_HASH_TABLE
		-- non-duplicate http parameters from either the GET-data (URI query string)
		-- or POST-data (`raw_stdin_content')
		do
			Result := parameters.new_method_parameters
		end

feature {NONE} -- Internal attributes

	broker: FCGI_REQUEST_BROKER
		-- Internal request information and stream functionality.

	servlet: FCGI_HTTP_SERVLET

end