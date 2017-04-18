note
	description: "Retrieves data using the HTTP command GET, POST and HEAD"

	notes: "[
		See class [http://eiffel-loop.com/test/source/test/http/http_connection_test_set.html HTTP_CONNECTION_TEST_SET]
		for examples on how to use.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-14 12:25:34 GMT (Friday 14th April 2017)"
	revision: "6"

class
	EL_HTTP_CONNECTION

inherit
	EL_C_OBJECT
		export
			{NONE} all
		redefine
			is_memory_owned, c_free
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

	EL_MODULE_URL
		rename
			Url as Mod_url
		end

	EL_MODULE_BASE_64
		export
			{NONE} all
		end

	EL_MODULE_LIO
		export
			{NONE} all
		end

	EL_MODULE_UTF

	EL_STRING_CONSTANTS

	EL_SHARED_CURL_API

create
	make

feature {NONE} -- Initialization

	make
		do
			disable_cookies
			create last_string.make_empty
			create http_response.make_empty
			create headers.make_equal (0)
			create post_data.make_empty (0)
		end

feature -- Access

	cookie_load_path: EL_FILE_PATH

	cookie_store_path: EL_FILE_PATH

	error_code: INTEGER
		-- curl error code

	http_error_code: NATURAL
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
						if code_string.is_natural then
							Result := code_string.to_natural
						end
					end
				end
			end
		end

	http_error_name: STRING
		local
			code: NATURAL
		do
			code := http_error_code
			if (400 |..| 510).has (code.to_integer_32) then
				Result := Http_error_messages [code]
			else
				create Result.make_empty
			end
		end

	http_version: DOUBLE

	headers: EL_CURL_HEADER_TABLE
		-- request headers to send

	last_headers: EL_HTTP_HEADERS
		do
			create Result.make (last_string)
		end

	last_string: STRING

	url: ZSTRING

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
			url := Empty_string
			headers.wipe_out; post_data.set_count (0)
			dispose

			-- Workaround for a weird bug where a second call to read_string would hang
--			full_collect

			-- September 2016: It's possible this weird bug might have been resolved by the rewrite of code
			-- handling cURL C callbacks that happened in this month.
		end

	download (file_path: EL_FILE_PATH)
			-- save document downloaded using the HTTP GET command
		local
			download_cmd: EL_SAVE_DOWNLOAD_HTTP_COMMAND
		do
			create {EL_SAVE_DOWNLOAD_HTTP_COMMAND} download_cmd.make
			set_http_command (CURLOPT_httpget)
			set_cookies
			download_cmd.execute (Current, file_path)
		end

	open (a_url: like url)
		do
			if is_lio_enabled then
				lio.put_labeled_string ("open", a_url); lio.put_new_line
			end
			reset
			make_from_pointer (Curl.new_pointer)
			set_url (a_url)
		ensure
			opened: is_open
		end

	read_string_get
		-- read document string using the HTTP GET command
		do
			read_string (CURLOPT_httpget)
		end

	read_string_head
		-- read document headers string using the HTTP HEAD command
		do
			read_string (CURLOPT_nobody)
		end

	read_string_post
		-- read document string using the HTTP POST command
		do
			read_string (CURLOPT_post)
		end

feature -- Status setting

	disable_cookies
		do
			disable_cookie_store; disable_cookie_load
		end

	disable_cookie_store
		do
			create cookie_store_path
		end

	disable_cookie_load
		do
			create cookie_load_path
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
			post_data.set_count (0)
			error_code := 0
		end

	set_certificate_authority_info (cacert_path: EL_FILE_PATH)
		do
			set_curl_string_option (CURLOPT_cainfo, cacert_path)
		end

	set_cookie_paths (a_cookie_path: like cookie_store_path)
			-- Set both `cookie_load_path' and `cookie_store_path' to the same file
		do
			cookie_load_path := a_cookie_path
			cookie_store_path := a_cookie_path
		end

	set_cookie_load_path (a_cookie_load_path: like cookie_load_path)
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

	set_cookie_store_path (a_cookie_store_path: like cookie_store_path)
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

	set_post_parameters (parameters: EL_HTTP_HASH_TABLE)
		do
			set_post_data (parameters.url_query_string)
		end

	set_post_data (raw_string_8: STRING)
		-- You must make sure that the data is formatted the way you want the server to receive it.
		-- libcurl will not convert or encode it for you in any way. For example, the web server may
		-- assume that this data is url-encoded.
		do
			post_data.set_string (raw_string_8)
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

	set_url (a_url: like url)
		do
			url := a_url
--			Curl already does url encoding
			set_curl_string_8_option (CURLOPT_url, a_url.to_utf_8)
			-- Essential calls for using https
			if a_url.starts_with (Secure_protocol) then
				set_ssl_certificate_verification (is_certificate_verified)
				set_ssl_hostname_verification (is_host_verified)
			end
		end

	set_url_arguments (arguments: ZSTRING)
		local
			pos_qmark: INTEGER
			l_url: like url
		do
			l_url := url
			pos_qmark := l_url.index_of ('?', 1)
			if pos_qmark > 0 then
				l_url.replace_substring (arguments, pos_qmark + 1, l_url.count)
			else
				l_url.grow (l_url.count + arguments.count + 1)
				l_url.append_character ('?')
				l_url.append (arguments)
			end
			set_url (l_url)
		end

	set_user_agent (user_agent: STRING)
		do
			set_curl_string_8_option (CURLOPT_useragent, user_agent)
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

	set_curl_option_with_data (a_option: INTEGER; a_data_ptr: POINTER)
		do
			Curl.setopt_void_star (self_ptr, a_option, a_data_ptr)
		end

feature {NONE} -- Implementation

	read_string (a_http_command: like http_command)
		local
			download_cmd: EL_STRING_DOWNLOAD_HTTP_COMMAND
		do
			if a_http_command = CURLOPT_nobody then
				create {EL_HEADER_DOWNLOAD_HTTP_COMMAND} download_cmd.make
			else
				create {EL_STRING_DOWNLOAD_HTTP_COMMAND} download_cmd.make
				if a_http_command = CURLOPT_post and then post_data.count > 0 then
					set_curl_option_with_data (CURLOPT_postfields, post_data.item)
					set_curl_integer_option (CURLOPT_postfieldsize, post_data.count)
				end
			end
			set_http_command (a_http_command)
			set_cookies
			download_cmd.execute (Current)
			if has_error then
				last_string.wipe_out
			else
				last_string.share (download_cmd.string)
			end
		end

	set_cookies
		do
			if not cookie_store_path.is_empty then
				set_curl_string_option (CURLOPT_cookiejar, cookie_store_path)
			end
			if not cookie_load_path.is_empty then
				set_curl_string_option (CURLOPT_cookiefile, cookie_load_path)
			end
		end

	set_curl_boolean_option (a_option: INTEGER; flag: BOOLEAN)
		do
			Curl.setopt_integer (self_ptr, a_option, flag.to_integer)
		end

	set_curl_integer_option (a_option: INTEGER; option: INTEGER)
		do
			Curl.setopt_integer (self_ptr, a_option, option)
		end

	set_curl_string_32_option (a_option: INTEGER; string: STRING_32)
		do
			Curl.setopt_string (self_ptr, a_option, UTF.string_32_to_utf_8_string_8 (string))
		end

	set_curl_string_8_option (a_option: INTEGER; string: STRING)
		do
			Curl.setopt_string (self_ptr, a_option, string)
		end

	set_curl_string_option (a_option: INTEGER; string: ZSTRING)
		do
			Curl.setopt_string (self_ptr, a_option, string.to_utf_8)
		end

	set_http_command (a_http_command: like http_command)
		require
			valid_command: is_valid_http_command (a_http_command)
		do
			if http_command /= a_http_command then
				set_curl_boolean_option (a_http_command, True)
				http_command := a_http_command
			end
		end

feature {NONE} -- Implementation attributes

	http_command: INTEGER
		-- POST, HEAD (NOBODY) or GET

	http_response: CURL_STRING

	post_data: C_STRING

feature {NONE} -- Constants

	Doctype_declaration: STRING = "<!DOCTYPE"

	Http_error_messages: HASH_TABLE [STRING, NATURAL]
		once
			create Result.make (5)
			Result [400] := "Bad Request"
			Result [401] := "Unauthorized"
			Result [402] := "Payment Required"
			Result [403] := "Forbidden"
			Result [404] := "Not Found"
			Result [405] := "Method Not Allowed"
			Result [406] := "Not Acceptable"
			Result [407] := "Proxy Auth Required"
			Result [408] := "Request Timeout"
			Result [409] := "Conflict"
			Result [410] := "Gone"
			Result [411] := "Length Required"
			Result [412] := "Precondition Failed"
			Result [413] := "Request Entity too large"
			Result [414] := "Request-URI too long"
			Result [415] := "Unsupported Media Type"
			Result [416] := "Requested range not satisfiable"
			Result [417] := "Expectation Failed"
			Result [422] := "Unprocessable Entity"
			Result [423] := "Locked"
			Result [424] := "Failed Dependency"
			Result [425] := "Unordered Collection"
			Result [426] := "Upgrade Required"
			Result [449] := "Retry With"
			Result [500] := "Internal Server Error"
			Result [501] := "Not Implemented"
			Result [502] := "Bad gateway"
			Result [503] := "Service Unavailable"
			Result [504] := "Gateway Timeout"
			Result [505] := "HTTP Version Not Supported"
			Result [506] := "Variant Also Negotiates"
			Result [507] := "Insufficient Storage"
			Result [509] := "Bandwidth Limit Exceeded"
			Result [510] := "Not Extended"
		end

	Is_memory_owned: BOOLEAN = True

	Secure_protocol: ZSTRING
		once
			Result := "https:"
		end

	Title_tag: STRING = "<title>"

end
