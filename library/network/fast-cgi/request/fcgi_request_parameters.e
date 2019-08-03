note
	description: "HTTP parameters passed throught Fast CGI connection"
	notes: "[
		The uppercase "FCGI parameters" names exactly match the Fast CGI parameter names
		so that the reflection mechanism will work for setting them.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-03 16:29:42 GMT (Saturday 3rd August 2019)"
	revision: "13"

class
	FCGI_REQUEST_PARAMETERS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			make_default as make,
			field_included as is_any_field,
			export_name as export_default,
			import_name as from_upper_snake_case
		redefine
			make, Except_fields
		end

	EL_SETTABLE_FROM_ZSTRING
		rename
			make_default as make
		redefine
			set_table_field
		end

	EL_ZSTRING_CONSTANTS
		undefine
			is_equal
		end

	EL_MODULE_IP_ADDRESS

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

	set_auth_type (a_auth_type: like auth_type)
		do
			auth_type := a_auth_type
		end

	set_content (a_content: like content)
		do
			content := a_content
			headers.set_content_length (content.count)
		end

	set_document_root (a_document_root: like document_root)
		do
			document_root := a_document_root
		end

	set_gateway_interface (a_gateway_interface: like gateway_interface)
		do
			gateway_interface := a_gateway_interface
		end

	set_path (a_path: like path)
		do
			path := a_path
		end

	set_path_info (a_path_info: like path_info)
		do
			path_info := a_path_info
		end

	set_path_translated (a_path_translated: like path_translated)
		do
			path_translated := a_path_translated
		end

	set_query_string (a_query_string: like query_string)
		do
			query_string := a_query_string
		end

	set_remote_ident (a_remote_ident: like remote_ident)
		do
			remote_ident := a_remote_ident
		end

	set_request_method (a_request_method: like request_method)
		do
			request_method := a_request_method
		end

	set_request_uri (a_request_uri: like request_uri)
		do
			request_uri := a_request_uri
		end

	set_script_filename (a_script_filename: like script_filename)
		do
			script_filename := a_script_filename
		end

	set_script_name (a_script_name: like script_name)
		do
			script_name := a_script_name
		end

	set_script_url (a_script_url: like script_url)
		do
			script_url := a_script_url
		end

	set_server_addr (a_server_addr: like server_addr)
		do
			server_addr := a_server_addr
		end

	set_server_name (a_server_name: like server_name)
		do
			server_name := a_server_name
		end

	set_server_port (a_server_port: like server_port)
		do
			server_port := a_server_port
		end

	set_server_protocol (a_server_protocol: like server_protocol)
		do
			server_protocol := a_server_protocol
		end

	set_server_signature (a_server_signature: like server_signature)
		do
			server_signature := a_server_signature
		end

	set_server_software (a_server_software: like server_software)
		do
			server_software := a_server_software
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

	method_parameters: EL_URL_QUERY_HASH_TABLE
		-- non-duplicate http parameters from either the GET-data (URI query string)
		-- or POST-data (`raw_stdin_content')
		do
			if is_get_request then
				create Result.make (query_string)
			elseif is_post_request and headers.content_length > 0 then
				create Result.make (content)
			else
				create Result.make_default
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
			parts: EL_SPLIT_ZSTRING_LIST; scalar: NATURAL
		do
			scalar := 1_000_000
			create parts.make (server_software.substring_between (Forward_slash, character_string (' '), 1), Dot)
			from parts.start until parts.after loop
				Result := Result + scalar * parts.item.to_natural
				scalar := scalar // 1000
				parts.forth
			end
		end

feature -- Status query

	is_get_request: BOOLEAN
		do
			Result := Method_get ~ request_method
		end

	is_head_request: BOOLEAN
		do
			Result := Method_head ~ request_method
		end

	is_post_request: BOOLEAN
		do
			Result := Method_post ~ request_method
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

	set_table_field (table: like field_table; name: STRING; value: ZSTRING)

		local
			prefixes: like Header_prefixes
		do
			prefixes := Header_prefixes
			prefixes.find_first_true (agent starts_with (name, ?))
			if prefixes.found then
				if prefixes.index = 2 then
					-- remove HTTP_
					name.remove_head (prefixes.item.count)
				end
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

	Dot: STRING = "."

	Except_fields: STRING
		once
			Result := Precursor + ", content, headers"
		end

	Forward_slash: ZSTRING
		once
			Result := "/"
		end

	Header_prefixes: EL_ARRAYED_LIST [STRING]
		once
			create Result.make_from_array (<< "CONTENT_", "HTTP_" >>)
		end

	Method_get: ZSTRING
		once
			Result := "GET"
		end

	Method_head: ZSTRING
		once
			Result := "HEAD"
		end

	Method_post: ZSTRING
		once
			Result := "POST"
		end

	Request_url_template: ZSTRING
		once
			Result := "%S://%S:%S%S"
		end

end
