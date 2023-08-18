note
	description: "HTTP parameters passed throught Fast CGI connection and set reflectively"
	notes: "[
		Uppercase FastCGI parameters are translated to lowercase names that match class field names as for
		example:
		
			SCRIPT_FILENAME -> script_filename
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 17:11:18 GMT (Thursday 17th August 2023)"
	revision: "31"

class
	FCGI_REQUEST_PARAMETERS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			foreign_naming as Snake_case_upper,
			make_default as make,
			field_included as is_any_field
		redefine
			make, new_transient_fields
		end

	EL_SETTABLE_FROM_ZSTRING
		rename
			make_default as make
		redefine
			set_table_field
		end

	EL_MODULE_IP_ADDRESS; EL_MODULE_TUPLE

	EL_CHARACTER_32_CONSTANTS

create
	make, make_from_table

feature {NONE} -- Initialization

	make
		do
			Precursor
			create headers.make
			create content.make_empty
		end

feature -- Element change

	set_content (a_content: like content)
		do
			content := a_content
			headers.set_content_length (content.count)
		end

	wipe_out
		do
			reset_fields
			headers.wipe_out
			content.wipe_out
		end

feature -- Access

	content: STRING
		-- raw stdin content (excluded field)

	full_request_url: ZSTRING
		do
			Result := Request_url_template #$ [protocol, host_name, server_port, request_uri]
		end

	headers: FCGI_HTTP_HEADERS

	host_name: ZSTRING
		do
			create Result.make_empty
			across << headers.x_forwarded_host, headers.host, server_name >> as name until not Result.is_empty loop
				if not name.item.is_empty then
					Result := name.item
				end
			end
		end

	protocol: STRING
		do
			Result := server_protocol.substring (1, server_protocol.index_of ('/', 1) - 1)
			Result.to_lower
			if https ~ once "on" then
				Result.append_character ('s')
			end
		end

	remote_address_32: NATURAL
		do
			Result := IP_address.to_number (remote_addr)
		end

	server_software_version: NATURAL
		local
			scalar: NATURAL
		do
			scalar := 1_000_000
			if attached server_software.substring_between (char ('/') * 1, space * 1, 1) as substring then
				across substring.split ('.') as list loop
					Result := Result + scalar * list.item.to_natural
					scalar := scalar // 1000
				end
			end
		end

feature -- Factory

	new_method_parameters: EL_URI_QUERY_ZSTRING_HASH_TABLE
		-- non-duplicate http parameters from either the GET-data (URI query string)
		-- or POST-data (`raw_stdin_content')
		do
			if is_post_request and headers.content_length > 0 then
				create Result.make_url (content)

			elseif (is_get_request or is_head_request) and query_string.count > 0 then
				create Result.make_url (query_string)

			else
				create Result.make_default
			end
		end

feature -- Status query

	is_get_request: BOOLEAN
		do
			Result := Method.get ~ request_method
		end

	is_head_request: BOOLEAN
		do
			Result := Method.head ~ request_method
		end

	is_post_request: BOOLEAN
		do
			Result := Method.post ~ request_method
		end

feature -- Numeric parameters

	remote_port: INTEGER

	server_port: INTEGER

feature -- STRING_8 parameters

	https: STRING

	remote_addr: STRING
		-- remote address formatted as x.x.x.x where 0 <= x and x <= 255

	server_protocol: STRING

	server_signature: STRING

feature -- ZSTRING parameters

	auth_type: ZSTRING

	document_root: ZSTRING

	gateway_interface: ZSTRING

	path: ZSTRING

	path_info: ZSTRING

	path_translated: ZSTRING

	query_string: ZSTRING

	remote_ident: ZSTRING

	remote_user: ZSTRING

	request_method: ZSTRING

	request_uri: ZSTRING

	script_filename: ZSTRING

	script_name: ZSTRING

	script_url: ZSTRING

	server_addr: ZSTRING

	server_name: ZSTRING

	server_software: ZSTRING

feature {NONE} -- Implementation

	new_transient_fields: STRING
		do
			Result := Precursor + ", content, headers"
		end

	set_table_field (table: like field_table; name: STRING; value: ZSTRING)

		do
			if name.starts_with (Header_prefix.content) then
				headers.set_field (name, value)

			elseif name.starts_with (Header_prefix.http) then
				-- trim "HTTP_"
				name.remove_head (Header_prefix.http.count)
				headers.set_field (name, value)
			else
				Precursor (table, name, value)
			end
		end

	starts_with (name, a_prefix: STRING): BOOLEAN
		do
			Result := name.starts_with (a_prefix)
		end

feature {NONE} -- Constants

	Snake_case_upper: EL_SNAKE_CASE_TRANSLATER
		once
			Result := {EL_CASE}.Upper
		end

	Header_prefix: TUPLE [content, http: STRING]
		once
			create Result
			Tuple.fill (Result, "CONTENT_, HTTP_")
		end

	Method: TUPLE [get, head, post: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "GET, HEAD, POST")
		end

	Request_url_template: ZSTRING
		once
			Result := "%S://%S:%S%S"
		end

end