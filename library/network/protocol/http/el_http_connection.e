note
	description: "Retrieves data using the HTTP command GET, POST and HEAD"
	notes: "[
		See class [http://eiffel-loop.com/test/source/test/http/http_connection_test_set.html HTTP_CONNECTION_TEST_SET]
		for examples on how to use.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-05 11:00:42 GMT (Sunday 5th September 2021)"
	revision: "32"

class
	EL_HTTP_CONNECTION

inherit
	EL_OWNED_C_OBJECT
		export
			{NONE} all
		end

	EL_CURL_OPTION_CONSTANTS
		rename
			is_valid as is_valid_option_constant
		export
			{NONE} all
			{ANY} is_valid_http_command
		end

	EL_CURL_SSL_CONSTANTS
		export
			{NONE} all
		end

	EL_CURL_INFO_CONSTANTS
		export
			{NONE} all
		end

	CURL_FORM_CONSTANTS
		rename
			is_valid as is_valid_form_constant
		export
			{NONE} all
		end

	EL_MODULE_BASE_64

	EL_MODULE_LIO

	EL_MODULE_URI

	EL_SHARED_HTTP_STATUS

	EL_ZSTRING_CONSTANTS

	EL_SHARED_CURL_API

	EL_SHARED_UTF_8_ZCODEC

	EL_PROTOCOL_CONSTANTS
		export
			{NONE} all
		end

	STRING_HANDLER

create
	make

feature {NONE} -- Initialization

	make
		do
			create last_string.make_empty
			create http_response.make_empty
			create headers.make_equal (0)
			create post_data.make (0)
			create user_agent.make_empty
			create url.make_empty
		end

feature -- Access

	content: ZSTRING
		do
			create Result.make_from_utf_8 (last_string)
		end

	cookie_load_path: detachable EL_FILE_PATH

	cookie_store_path: detachable EL_FILE_PATH

	error_code: INTEGER
		-- curl error code

	headers: EL_CURL_HEADER_TABLE
		-- request headers to send

	http_error_code: NATURAL_16
		local
			pos_title, pos_space: INTEGER
			code_string: STRING
		do
			if last_string.starts_with (Doctype_declaration) then
				pos_title := last_string.substring_index (Title_tag, 1)
				if pos_title > 0 then
					pos_space := last_string.index_of (' ', pos_title)
					if pos_space > 0 then
						code_string := last_string.substring (pos_title + Title_tag.count, pos_space - 1)
						if code_string.is_natural_16 then
							Result := code_string.to_natural_16
						end
					end
				end
			end
		end

	http_error_name: STRING
		do
			Result := Http_status.name (http_error_code)
		end

	http_version: DOUBLE

	last_headers: EL_HTTP_HEADERS
		do
			create Result.make (last_string)
		end

	last_string: STRING

	url: ZSTRING

	user_agent: STRING

feature -- Status query

	has_error: BOOLEAN
		do
			Result := error_code /= 0
		end

	has_http_error (code: NATURAL): BOOLEAN
		do
			Result := http_error_code = code
		end

	has_some_http_error: BOOLEAN
		do
			Result := (400 |..| 510).has (http_error_code.to_integer_32)
		end

	is_certificate_verified: BOOLEAN

	is_gateway_timeout: BOOLEAN
		do
			 Result := has_http_error (504)
		end

	is_host_verified: BOOLEAN

	is_open: BOOLEAN
		do
			Result := is_attached (self_ptr)
		end

	is_service_unavailable: BOOLEAN
		do
			Result := has_http_error (503)
		end

	is_url_encoded (a_url: READABLE_STRING_GENERAL): BOOLEAN
		local
			s: EL_STRING_8_ROUTINES
		do
			if a_url.is_string_8 and then attached a_url.as_string_8 as str_8 then
				Result := s.is_ascii (str_8)
			end
		end

feature -- Basic operations

	close
			-- write any cookies if `cookie_store_path' is set and closes connection
		do
			url.wipe_out
			headers.wipe_out; post_data_count := 0
			if post_data.count > Max_post_data_count then
				post_data.resize (Max_post_data_count)
			end
			post_data.item.memory_set (0, post_data.count)
			dispose

			-- Workaround for a weird bug where a second call to read_string would hang
--			full_collect

			-- September 2016: It's possible this weird bug might have been resolved by the rewrite of code
			-- handling cURL C callbacks that happened in this month.
		end

	download (file_path: EL_FILE_PATH)
			-- save document downloaded using the HTTP GET command
		do
			do_command (create {EL_FILE_DOWNLOAD_HTTP_COMMAND}.make (Current, file_path))
		end

	open (a_url: READABLE_STRING_GENERAL)
		require
			not_already_url_encoded: not is_url_encoded (a_url)
		do
			open_with_parameters (a_url, Default_parameter_table)
		end

	open_with_parameters (a_url: READABLE_STRING_GENERAL; parameter_table: like Default_parameter_table)
		do
			if is_lio_enabled then
				lio.put_labeled_string ("open", a_url); lio.put_new_line
			end
			reset
			make_from_pointer (Curl.new_pointer)
			set_url_with_parameters (a_url, parameter_table)
			set_curl_boolean_option (CURLOPT_verbose, False)
			if not user_agent.is_empty then
				set_curl_string_8_option (CURLOPT_useragent, user_agent)
			end
		ensure
			opened: is_open
		end

	open_url (a_url: EL_URL)
		do
			url.wipe_out; a_url.append_to (url)
			if is_lio_enabled then
				lio.put_labeled_string ("open_url", url); lio.put_new_line
			end
			reset
			make_from_pointer (Curl.new_pointer)
			set_curl_string_8_option (CURLOPT_url, a_url)
			set_curl_boolean_option (CURLOPT_verbose, False)
			if not user_agent.is_empty then
				set_curl_string_8_option (CURLOPT_useragent, user_agent)
			end
		ensure
			opened: is_open
		end

	read_string_get
		-- read document string using the HTTP GET command
		do
			do_command (create {EL_GET_HTTP_COMMAND}.make (Current))
		end

	read_string_head
		-- read document headers string using the HTTP HEAD command
		do
			do_command (create {EL_HEAD_HTTP_COMMAND}.make (Current))
		end

	read_string_post
		-- read document string using the HTTP POST command
		do
			do_command (create {EL_POST_HTTP_COMMAND}.make (Current))
		end

feature -- Status setting

	disable_cookie_load
		do
			cookie_load_path := Void
		end

	disable_cookie_store
		do
			cookie_store_path := Void
		end

	disable_cookies
		do
			disable_cookie_store; disable_cookie_load
		end

	disable_verbose
		do
			set_curl_boolean_option (CURLOPT_verbose, False)
		end

	enable_verbose
		do
			set_curl_boolean_option (CURLOPT_verbose, True)
		end

	reset_cookie_session
			-- Mark this as a new cookie "session". It will force libcurl to ignore all cookies it is about to load
			-- that are "session cookies" from the previous session. By default, libcurl always stores and loads all cookies,
			-- independent if they are session cookies or not. Session cookies are cookies without expiry date and they are meant
			-- to be alive and existing for this "session" only.
		do
			set_curl_boolean_option (CURLOPT_cookiesession, True)
		end

	set_redirection_follow
		do
			set_curl_boolean_option (CURLOPT_followlocation, True)
		end

feature -- Element change

	reset
		do
			last_string.wipe_out
			url.wipe_out
			post_data_count := 0
			error_code := 0
		end

	set_certificate_authority_info (cacert_path: EL_FILE_PATH)
		do
			set_curl_string_option (CURLOPT_cainfo, cacert_path)
		end

	set_cookie_load_path (a_cookie_load_path: EL_FILE_PATH)
		-- Enables the cookie engine, making the connection parse and send cookies on subsequent requests.
		-- The cookie data can be in either the old Netscape / Mozilla cookie data format or just
		-- regular HTTP headers (Set-Cookie style) dumped to a file.

		-- Exercise caution if you are using this option and multiple transfers may occur.
		-- If you use the Set-Cookie format and don't specify a domain then the cookie is sent
		-- for any domain (even after redirects are followed) and cannot be modified by a server-set
		-- cookie. If a server sets a cookie of the same name then both will be sent on a future
		-- transfer to that server, likely not what you intended. To address these issues set a domain
		-- in Set-Cookie (doing that will include sub-domains) or use the Netscape format.

		-- See also: https://curl.haxx.se/libcurl/c/CURLOPT_COOKIEFILE.html
		do
			cookie_load_path := a_cookie_load_path
		end

	set_cookie_paths (a_cookie_path: EL_FILE_PATH)
			-- Set both `cookie_load_path' and `cookie_store_path' to the same file
		do
			cookie_load_path := a_cookie_path
			cookie_store_path := a_cookie_path
		end

	set_cookie_store_path (a_cookie_store_path: EL_FILE_PATH)
			-- This will make the connection write all internally known cookies to the
			-- specified file when close is called.

			-- See also: https://curl.haxx.se/libcurl/c/CURLOPT_COOKIEJAR.html
		do
			cookie_store_path := a_cookie_store_path
		end

	set_http_version (version: DOUBLE)
		require
			valid_version: (<< 0.0, 1.0, 1.1 >>).has (version)
		local
			option: INTEGER
		do
			http_version := version
			inspect (version * 10).floor
				when 1_0 then
					option := curl_http_version_1_0
				when 1_1 then
					option := curl_http_version_1_1
			else
				option := curl_http_version_none
				http_version := version.zero
			end
			set_curl_integer_option (CURLOPT_http_version, option)
		end

	set_post_data (raw_string_8: STRING)
		-- You must make sure that the data is formatted the way you want the server to receive it.
		-- libcurl will not convert or encode it for you in any way. For example, the web server may
		-- assume that this data is url-encoded.
		do
			post_data_count := raw_string_8.count
			if post_data_count > post_data.count then
				post_data.resize (post_data_count)
			end
			post_data.put_special_character_8 (raw_string_8.area, 0, 0, post_data_count)
		end

	set_post_parameters (parameters: EL_URI_QUERY_ZSTRING_HASH_TABLE)
		do
			set_post_data (parameters.query_string (True, False))
		end

	set_ssl_certificate_verification (flag: BOOLEAN)
			-- Curl verifies whether the certificate is authentic,
			-- i.e. that you can trust that the server is who the certificate says it is.
		do
			set_curl_boolean_option (CURLOPT_ssl_verifypeer, flag)
		end

	set_ssl_hostname_verification (flag: BOOLEAN)
			-- If the site you're connecting to uses a different host name that what
     		-- they have mentioned in their server certificate's commonName (or
     		-- subjectAltName) fields, libcurl will refuse to connect.
		do
			set_curl_boolean_option (CURLOPT_ssl_verifyhost, flag)
		end

	set_ssl_tls_version (version: DOUBLE)
		require
			valid_unix_version: {PLATFORM}.is_unix implies (<< version.zero, 1.0, 1.1, 1.2 >>).has (version)
			valid_windows_version: {PLATFORM}.is_windows implies version.zero ~ version
		local
			option: INTEGER
		do
			inspect (version * 10).floor
				--
				when 1_0 then
					option := curl_sslversion_TLSv1_0
				when 1_1 then
					option := curl_sslversion_TLSv1_1
				when 1_2 then
					option := curl_sslversion_TLSv1_2
			else
				option := curl_sslversion_TLSv1
			end
			set_curl_integer_option (CURLOPT_sslversion, option)
		end

	set_ssl_tls_version_1_x
		do
			set_curl_integer_option (CURLOPT_sslversion, curl_sslversion_TLSv1)
		end

	set_ssl_version (version: INTEGER)
			-- 0 is default
		require
			valid_version: (<< 0, 2, 3 >>).has (version)
		local
			option: INTEGER
		do
			inspect version
				when 2 then
					option := curl_sslversion_sslv2
				when 3 then
					option := curl_sslversion_sslv3
			else
				option := curl_sslversion_default
			end
			set_curl_integer_option (CURLOPT_sslversion, option)
		end

	set_timeout (millisecs: INTEGER)
			-- set maximum time in milli-seconds the request is allowed to take
		do
			set_curl_integer_option (CURLOPT_timeout_ms, millisecs)
		end

	set_timeout_seconds (seconds: INTEGER)
			-- set maximum time in seconds the request is allowed to take
		do
			set_curl_integer_option (CURLOPT_timeout, seconds)
		end

	set_timeout_to_connect (seconds: INTEGER)
			--
		do
			set_curl_integer_option (CURLOPT_timeout, seconds)
		end

	set_url (a_url: READABLE_STRING_GENERAL)
		do
			set_url_with_parameters (a_url, Default_parameter_table)
		end

	set_url_with_parameters (a_url: READABLE_STRING_GENERAL; parameter_table: like Default_parameter_table)
		local
			l_encoded: like encoded
		do
			url.wipe_out
			url.append_string_general (a_url)
			l_encoded := encoded (a_url, parameter_table)
			if is_lio_enabled then
				lio.put_line (l_encoded)
			end
--			Curl already does url encoding
			set_curl_string_8_option (CURLOPT_url, l_encoded)
			-- Essential calls for using https
			if URI.is_https (a_url) then
				set_ssl_certificate_verification (is_certificate_verified)
				set_ssl_hostname_verification (is_host_verified)
			end
		end

	set_user_agent (a_user_agent: STRING)
		do
			user_agent := a_user_agent
			if is_open then
				set_curl_string_8_option (CURLOPT_useragent, a_user_agent)
			end
		end

feature {NONE} -- Disposal

	c_free (this: POINTER)
			--
		do
			if not is_in_final_collect then
				Curl.clean_up (self_ptr)
			end
		end

feature {NONE} -- Experimental

	read_string_experiment
			-- Failed experiment. Might come back to it again
		local
			form_post, form_last: CURL_FORM
		do
			create form_post.make; create form_last.make
			set_form_parameters (form_post, form_last)

			create http_response.make_empty
--			set_write_function (self_ptr)
			set_curl_integer_option (CURLOPT_writedata, http_response.object_id)
			error_code := Curl.perform (self_ptr)
			last_string.share (http_response)
		end

	redirection_url: STRING
			-- Fails because Curlinfo_redirect_url will not satisfy contract CURL_INFO_CONSTANTS.is_valid
			-- For some reason Curlinfo_redirect_url is missing from CURL_INFO_CONSTANTS
		require
			no_error: not has_error
		local
			result_cell: CELL [STRING]
			status: INTEGER
		do
			create Result.make_empty
			create result_cell.put (Result)
			status := Curl.get_info (self_ptr, Curlinfo_redirect_url, result_cell)
			if status = 0 then
				Result := result_cell.item
			end
		end

	set_form_parameters (form_post, form_last: CURL_FORM)
			-- Haven't worked out how to use this yet
		do
--			across parameters as parameter loop
--				Curl.formadd_string_string (
--					form_post, form_last,
--					CURLFORM_COPYNAME, parameter.key,
--					CURLFORM_COPYCONTENTS, parameter.item,
--					CURLFORM_END
--				)
--			end
			Curl.setopt_form (self_ptr, CURLOPT_httppost, form_post)
		end

feature {EL_HTTP_COMMAND} -- Implementation

	do_transfer
			-- do data transfer to/from host
		local
			string_list: POINTER
		do
			string_list := headers.to_curl_string_list
			if is_attached (string_list) then
				set_curl_option_with_data (CURLOPT_httpheader, string_list)
			end
			error_code := Curl.perform (self_ptr)
			if is_attached (string_list) then
				curl.free_string_list (string_list)
			end
			if has_error and then is_lio_enabled then
				lio.put_integer_field ("CURL error code", error_code)
				lio.put_new_line
			end
		end

	enable_get_method
		do
			set_curl_boolean_option (CURLOPT_httpget, True)
			set_curl_boolean_option (CURLOPT_post, False)
		end

	enable_post_method
		do
			set_curl_boolean_option (CURLOPT_httpget, False)
			set_curl_boolean_option (CURLOPT_post, True)
			if post_data.count > 0 then
				set_curl_option_with_data (CURLOPT_postfields, post_data.item)
				set_curl_integer_option (CURLOPT_postfieldsize, post_data_count)
			end
		end

	set_cookie_options
		do
			if attached cookie_store_path as store_path then
				set_curl_string_option (CURLOPT_cookiejar, store_path)
			end
			if attached cookie_load_path as load_path then
				set_curl_string_option (CURLOPT_cookiefile, load_path)
			end
		end

	set_curl_boolean_option (a_option: INTEGER; flag: BOOLEAN)
		do
			Curl.setopt_integer (self_ptr, a_option, flag.to_integer)
		end

	set_header_function (callback, user_data: POINTER)
		do
			set_curl_option_with_data (CURLOPT_headerfunction, callback)
			set_curl_option_with_data (CURLOPT_headerdata, user_data)
		end

	set_nobody (flag: BOOLEAN)
		do
			set_curl_boolean_option (CURLOPT_nobody, flag)
		end

	set_write_function (callback, user_data: POINTER)
		do
			set_curl_option_with_data (CURLOPT_writefunction, callback)
			set_curl_option_with_data (CURLOPT_writedata, user_data)
		end

feature {NONE} -- Implementation

	do_command (command: EL_DOWNLOAD_HTTP_COMMAND)
		do
			command.execute
			if attached {EL_STRING_DOWNLOAD_HTTP_COMMAND} command as string_download then
				if has_error then
					last_string.wipe_out
				else
					last_string.share (string_download.string)
				end
			end
		end

	encoded (a_url: READABLE_STRING_GENERAL; parameter_table: like Default_parameter_table): like Once_uri_path
		local
			start_index, end_index, path_index, qmark_index, equal_index: INTEGER
			parameter_list: EL_SPLIT_STRING_LIST [STRING_32]
			parameter_string: STRING_32
		do
			Result := Once_uri_path
			Result.wipe_out
			start_index := a_url.substring_index (Colon_slash_x2, 1)
			qmark_index := a_url.index_of ('?', 1)
			if qmark_index > 0 then
				end_index := qmark_index - 1
			else
				end_index := a_url.count
			end
			if start_index > 0 then
				path_index := a_url.index_of ('/', start_index + 3)
				if path_index > 0 then
					Result.append_unencoded_substring_general (a_url, 1, path_index - 1)
					Result.append_substring_general (a_url, path_index, end_index)
				else
					Result.append_unencoded_substring_general (a_url, 1, end_index)
				end
			end
			if qmark_index > 0 then
				Result.append_character ('?')
				parameter_string := a_url.substring (qmark_index + 1, a_url.count).to_string_32
				create parameter_list.make (parameter_string, "&")
				from parameter_list.start until parameter_list.after loop
					if parameter_list.index > 1 then
						Result.append_character ('&')
					end
					start_index := parameter_list.item_start_index
					end_index := parameter_list.item_end_index
					equal_index := parameter_list.item (False).index_of ('=', start_index)
					if start_index < equal_index  and equal_index < parameter_list.item_end_index then
						Result.append_substring_general (parameter_string, start_index, equal_index - 1)
						Result.append_character ('=')
						Result.append_substring_general (parameter_string, equal_index + 1, end_index)
					end
					parameter_list.forth
				end
			end
			across parameter_table as table loop
				if table.is_first and qmark_index = 0 then
					Result.append_character ('?')
				end
				Result.append_general (table.key)
				Result.append_character ('=')
				Result.append_general (table.item)
			end
		end

	set_curl_integer_option (a_option: INTEGER; option: INTEGER)
		do
			Curl.setopt_integer (self_ptr, a_option, option)
		end

	set_curl_option_with_data (a_option: INTEGER; a_data_ptr: POINTER)
		do
			Curl.setopt_void_star (self_ptr, a_option, a_data_ptr)
		end

	set_curl_string_32_option (a_option: INTEGER; string: STRING_32)
		do
			Curl.setopt_string (self_ptr, a_option, Utf_8_codec.as_utf_8 (string, False))
		end

	set_curl_string_8_option (a_option: INTEGER; string: STRING)
		do
			Curl.setopt_string (self_ptr, a_option, string)
		end

	set_curl_string_option (a_option: INTEGER; string: ZSTRING)
		do
			Curl.setopt_string (self_ptr, a_option, string.to_utf_8 (False))
		end

feature {NONE} -- Implementation attributes

	http_response: CURL_STRING

	post_data: MANAGED_POINTER

	post_data_count: INTEGER

feature {NONE} -- Constants

	Default_parameter_table: HASH_TABLE [READABLE_STRING_GENERAL, STRING]
		once
			create {HASH_TABLE [STRING, STRING]} Result.make (0)
		end

	Doctype_declaration: STRING = "<!DOCTYPE"

	Once_uri_path: EL_URI_PATH_STRING_8
		once
			create Result.make_empty
		end

	Max_post_data_count: INTEGER = 1024

	Title_tag: STRING = "<title>"

end