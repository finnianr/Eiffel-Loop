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
	date: "2017-11-10 10:32:39 GMT (Friday 10th November 2017)"
	revision: "2"

class
	FCGI_REQUEST_PARAMETERS

inherit
	EL_REFLECTIVELY_SETTABLE [ZSTRING]
		rename
			make_default as make,
			name_adaptation as from_upper_snake_case
		redefine
			make, set_field, Except_fields
		end

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
		end

	wipe_out
		do
			set_default_values
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

	method_parameters: EL_HTTP_HASH_TABLE
		-- non-duplicate http parameters from either the GET-data (URI query string)
		-- or POST-data (`raw_stdin_content')
		do
			if is_get_request then
				create Result.make_from_url_query (query_string)
			elseif is_post_request and headers.content_length > 0 then
				create Result.make_from_url_query (content)
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
		local
			l_result: NATURAL_32_REF
		do
			if remote_addr.occurrences ('.') = 3 then
				create l_result
				remote_addr.do_with_splits (Dot, agent append_byte (?, l_result))
				Result := l_result.item
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

	server_protocol: STRING

feature -- ZSTRING parameters

	auth_type: ZSTRING

	document_root: ZSTRING

	gateway_interface: ZSTRING

	path: ZSTRING

	path_info: ZSTRING

	path_translated: ZSTRING

	query_string: ZSTRING

	remote_addr: ZSTRING
		-- remote address formatted as x.x.x.x where 0 <= x and x <= 255

	remote_ident: ZSTRING

	remote_user: ZSTRING

	request_method: ZSTRING

	request_uri: ZSTRING

	script_filename: ZSTRING

	script_name: ZSTRING

	script_url: ZSTRING

	server_addr: ZSTRING

	server_name: ZSTRING

	server_signature: ZSTRING

	server_software: ZSTRING

feature -- Element change

	set_field (name: STRING; value: ZSTRING)
		local
			prefixes: like Header_prefixes
		do
			prefixes := Header_prefixes
			prefixes.find_first (True, agent name.starts_with)
			if prefixes.found then
				if prefixes.index = 2 then
					-- remove HTTP_
					name.remove_head (prefixes.item.count)
				end
				headers.set_field (name, value)
			else
				Precursor (name, value)
			end
		end

feature {NONE} -- Implementation

	append_byte (byte_string: ZSTRING; n: NATURAL_32_REF)
		do
			n.set_item (n.item |<< 8 | byte_string.to_natural_32)
		end

feature {NONE} -- Constants

	Dot: ZSTRING
		once
			Result := "."
		end

	Except_fields: ZSTRING
		once
			Result := Precursor + ", content"
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
