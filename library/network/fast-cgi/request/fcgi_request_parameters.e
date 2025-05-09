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
	date: "2025-05-09 10:13:14 GMT (Friday 9th May 2025)"
	revision: "38"

class
	FCGI_REQUEST_PARAMETERS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			foreign_naming as Snake_case_upper,
			make_default as make,
			field_included as is_any_field
		redefine
			make, new_transient_fields, new_representations
		end

	EL_SETTABLE_FROM_ZSTRING
		rename
			make_default as make
		redefine
			set_table_field_utf_8
		end

	EL_MODULE_IP_ADDRESS; EL_MODULE_TUPLE

create
	make, make_from_utf_8_table

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

	host_name: STRING
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
			if https = Secure.on then
				Result.append_character ('s')
			end
		end

	remote_address_32: NATURAL
		do
			Result := IP_address.to_number (remote_addr)
		end

	request_method_name: STRING
		do
			Result := Method.name (request_method)
		end

	server_software_version: NATURAL
		local
			scalar: NATURAL
		do
			scalar := 1_000_000
			if attached server_software.substring_between_characters ('/', ' ', 1) as substring then
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
			Result := request_method = Method.get
		end

	is_head_request: BOOLEAN
		do
			Result := request_method = Method.head
		end

	is_post_request: BOOLEAN
		do
			Result := request_method = Method.post
		end

feature -- Numeric parameters

	remote_port: INTEGER

	server_port: INTEGER

feature -- Enumeration parameters

	request_method: NATURAL_8

	https: NATURAL_8

feature -- STRING_8 parameters

	remote_addr: STRING
		-- remote address formatted as x.x.x.x where 0 <= x and x <= 255

	query_string: STRING

	server_protocol: STRING

	server_name: STRING

feature -- EL_SUBSTRING_8 parameters

	auth_type: EL_MANIFEST_SUBSTRING_8

feature -- ZSTRING parameters

	path: ZSTRING

	path_info: ZSTRING

	request_uri: ZSTRING

	server_software: ZSTRING

feature -- EL_ZSUBSTRING parameters

	gateway_interface: EL_MANIFEST_SUB_ZSTRING

	document_root: EL_MANIFEST_SUB_ZSTRING

	path_translated: EL_MANIFEST_SUB_ZSTRING

	remote_ident: EL_MANIFEST_SUB_ZSTRING

	remote_user: EL_MANIFEST_SUB_ZSTRING

	script_filename: EL_MANIFEST_SUB_ZSTRING

	script_name: EL_MANIFEST_SUB_ZSTRING

	script_url: EL_MANIFEST_SUB_ZSTRING

	server_addr: EL_MANIFEST_SUB_ZSTRING

	server_signature: EL_MANIFEST_SUB_ZSTRING

feature {NONE} -- Implementation

	new_transient_fields: STRING
		do
			Result := Precursor + ", content, headers"
		end

	new_representations: like Default_representations
		do
			create Result.make_assignments (<<
				["https", Secure.to_representation],
				["request_method", Method.to_representation]
			>>)
		end

	set_table_field_utf_8 (table: like field_export_table; name, value_utf_8: READABLE_STRING_8)
		local
			index: INTEGER
		do
			if name.starts_with (Header_prefix.content) then
				headers.set_field_from_utf_8 (name, value_utf_8)

			elseif name.starts_with (Header_prefix.http) then
				index := Header_prefix.http.count + 1
				if attached Immutable_8.shared_substring_end (name, index) as short_name then
				-- trimmed "HTTP_"
					headers.set_field_from_utf_8 (short_name, value_utf_8)
				end
			else
				Precursor (table, name, value_utf_8)
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

	Request_url_template: ZSTRING
		once
			Result := "%S://%S:%S%S"
		end

	Method: FCGI_REQUEST_METHOD_ENUM
		once
			create Result.make
		end

	Secure: EL_BOOLEAN_ON_OFF_ENUM
		once
			create Result.make
		end

end