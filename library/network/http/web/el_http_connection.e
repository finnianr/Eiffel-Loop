note
	description: "Retrieves data using the HTTP command GET, POST and HEAD"
	notes: "[
		See class [http://eiffel-loop.com/test/source/test/http/http_connection_test_set.html HTTP_CONNECTION_TEST_SET]
		for examples on how to use.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-11 15:23:09 GMT (Saturday 11th March 2023)"
	revision: "38"

class
	EL_HTTP_CONNECTION

inherit
	EL_OWNED_C_OBJECT
		export
			{NONE} all
		end

	EL_HTTP_CONNECTION_IMPLEMENTATION
		rename
			is_valid as is_valid_option_constant
		export
			{ANY} content, is_valid_http_command, http_error_code, http_error_name, last_headers,
				set_certificate_authority_info
		end

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

	cookie_load_path: detachable FILE_PATH

	cookie_store_path: detachable FILE_PATH

	error_code: INTEGER
		-- curl error code

	http_version: DOUBLE

	last_string: STRING

	url: EL_URL

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

	download (file_path: FILE_PATH)
			-- save document downloaded using the HTTP GET command
		do
			do_command (create {EL_FILE_DOWNLOAD_HTTP_COMMAND}.make (Current, file_path))
		end

	open (a_url: READABLE_STRING_GENERAL)
		do
			open_url (URI.new_url (a_url))
		end

	open_with_parameters (a_url: EL_URL; parameter_table: like new_parameter_table)
		do
			reset
			make_from_pointer (Curl.new_pointer)
			set_url_with_parameters (a_url, parameter_table)
			set_curl_boolean_option (CURLOPT_verbose, False)
			if is_lio_enabled then
				lio.put_labeled_string ("open", url); lio.put_new_line
			end
			if not user_agent.is_empty then
				set_curl_string_8_option (CURLOPT_useragent, user_agent)
			end
		ensure
			opened: is_open
		end

	open_url (a_url: EL_URL)
		do
			open_with_parameters (a_url, Void)
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

	set_cookie_load_path (a_cookie_load_path: FILE_PATH)
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

	set_cookie_paths (a_cookie_path: FILE_PATH)
			-- Set both `cookie_load_path' and `cookie_store_path' to the same file
		do
			cookie_load_path := a_cookie_path
			cookie_store_path := a_cookie_path
		end

	set_cookie_store_path (a_cookie_store_path: FILE_PATH)
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

	set_url (a_url: EL_URL)
		do
			set_url_with_parameters (a_url, Void)
		end

	set_url_with_parameters (a_url: EL_URL; parameter_table: like new_parameter_table)
		do
			url.wipe_out
			url.append (a_url)
			if attached parameter_table as table then
				url.append_query_from_table (table)
			end
--			Curl already does url encoding
			set_curl_string_8_option (CURLOPT_url, url)
			-- Essential calls for using https
			if url.is_https then
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

	set_cookie_options
		do
			if attached cookie_store_path as store_path then
				set_curl_string_option (CURLOPT_cookiejar, store_path)
			end
			if attached cookie_load_path as load_path then
				set_curl_string_option (CURLOPT_cookiefile, load_path)
			end
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

feature {NONE} -- Implementation attributes

	headers: EL_CURL_HEADER_TABLE
		-- request headers to send

	http_response: CURL_STRING

end