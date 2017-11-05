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
	date: "2017-10-31 16:32:18 GMT (Tuesday 31st October 2017)"
	revision: "1"

class
	FCGI_REQUEST_PARAMETERS

create
	make

feature {NONE} -- Initialization

	make
		do
			create current_object.make (Current)
			create path_info.make_empty
			create raw_stdin_content.make (0)
			reset
		end

feature -- Element change

	append_raw_stdin_content (str: STRING)
		do
			raw_stdin_content.append (str)
		end

	reset
		local
			i, field_count: INTEGER; object: like current_object
			omitted: like Ommitted_indices
		do
			path_info.wipe_out
			raw_stdin_content.wipe_out

			omitted := Ommitted_indices
			object := current_object
			field_count := object.field_count
			from i := 1 until i > field_count loop
				if not omitted.has (i) then
					object.set_reference_field (i, Default_value)
				end
				i := i + 1
			end
			content_length := -1
		end

	set_content_length (value: ZSTRING)
		do
			if value.is_integer then
				content_length := value.to_integer
			end
		end

	set_field (name: STRING; value: ZSTRING)
		do
			if attached {PROCEDURE} Setter_routines [name] as set then
				set.set_target (Current)
				set (value)
			else
				Field_indices.search (name)
				if Field_indices.found then
					current_object.set_reference_field (Field_indices.found_item, value.twin)
				end
			end
		end

	set_path_info (value: ZSTRING)
		do
			path_info.append (value)
			path_info.prune_all_leading ('/')
		end

feature -- Access

	content_length: INTEGER

	http_parameters: EL_HTTP_HASH_TABLE
		-- If the request is a GET then the parameters are stored in the query
		-- string. Otherwise, the parameters are in the stdin data.
		do
			if request_method ~ Method_get then
				create Result.make_from_url_query (query_string)
			elseif request_method ~ Method_post and content_length > 0 then
				create Result.make_from_url_query (raw_stdin_content)
			else
				create Result.make_default
			end
		end

	is_head_request: BOOLEAN
		do
			Result := Method_head ~ request_method
		end

	raw_stdin_content: STRING

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

feature -- FCGI parameters

	auth_type: ZSTRING

	content_type: ZSTRING

	document_root: ZSTRING

	gateway_interface: ZSTRING

	http_accept: ZSTRING

	http_accept_encoding: ZSTRING

	http_accept_language: ZSTRING

	http_cache_control: ZSTRING

	http_connection: ZSTRING

	http_cookie: ZSTRING

	http_from: ZSTRING

	http_host: ZSTRING

	http_referer: ZSTRING

	http_upgrade_insecure_requests: ZSTRING

	http_user_agent: ZSTRING

	https: ZSTRING

	path: ZSTRING

	path_info: ZSTRING

	path_translated: ZSTRING

	query_string: ZSTRING

	remote_addr: ZSTRING
		-- remote address formatted as x.x.x.x where 0 <= x and x <= 255

	remote_ident: ZSTRING

	remote_port: ZSTRING

	remote_user: ZSTRING

	request_method: ZSTRING

	request_uri: ZSTRING

	script_filename: ZSTRING

	script_name: ZSTRING

	script_url: ZSTRING

	server_addr: ZSTRING

	server_name: ZSTRING

	server_port: ZSTRING

	server_protocol: ZSTRING

	server_signature: ZSTRING

	server_software: ZSTRING

feature {NONE} -- Implementation

	append_byte (byte_string: ZSTRING; n: NATURAL_32_REF)
		do
			n.set_item (n.item |<< 8 | byte_string.to_natural_32)
		end

feature {NONE} -- Internal attributes

	current_object: REFLECTED_REFERENCE_OBJECT

feature {NONE} -- Constants

	Dot: ZSTRING
		once
			Result := "."
		end

	Default_value: ZSTRING
		once
			create Result.make_empty
		end

	Field_indices: HASH_TABLE [INTEGER, STRING]
		local
			i, field_count: INTEGER; object: like current_object
		once
			object := current_object
			field_count := object.field_count
			create Result.make (field_count)
			from i := 1 until i > field_count loop
				if not Ommitted_indices.has (i) then
					Result.extend (i, object.field_name (i))
				end
				i := i + 1
			end
		end

	Internal_fields: ARRAY [STRING]
		once
			Result := << "current_object", "raw_stdin_content" >>
			Result.compare_objects
		end

	Method_get: ZSTRING
		once
			Result := "GET"
		end

	Method_post: ZSTRING
		once
			Result := "POST"
		end

	Method_head: ZSTRING
		once
			Result := "HEAD"
		end

	Ommitted_indices: ARRAYED_LIST [INTEGER]
		local
			i, field_count: INTEGER; object: like current_object
			field_name: STRING
		once
			object := current_object
			field_count := object.field_count
			create Result.make (10)
			from i := 1 until i > field_count loop
				field_name := object.field_name (i)
				if Setter_routines.has_key (field_name) or else Internal_fields.has (field_name) then
					Result.extend (i)
				end
				i := i + 1
			end
		end

	Setter_routines: EL_PROCEDURE_TABLE
		once
			create Result.make (<<
				["content_length", agent set_content_length],
				["path_info", agent set_path_info]
			>>)
		end

end
