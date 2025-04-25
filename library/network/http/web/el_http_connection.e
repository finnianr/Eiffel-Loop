note
	description: "[
		Retrieves data using the HTTP command GET, POST and HEAD.
		Accessible via ${EL_MODULE_WEB}.Web
	]"
	notes: "[
		See class ${HTTP_CONNECTION_TEST_SET} for usage examples.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 7:24:11 GMT (Friday 25th April 2025)"
	revision: "59"

class
	EL_HTTP_CONNECTION

inherit
	EL_OWNED_C_OBJECT
		export
			{NONE} all
		end

	EL_HTTP_CONNECTION_BASE
		rename
			is_valid as is_valid_option_constant
		export
			{ANY} content, is_valid_http_command
		redefine
			make
		end

	EL_MODULE_HTML

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create url.make_empty
			create user_agent.make_empty
			redirection_url := Empty_string_8
			set_silent_output
		end

feature -- Measurement

	timeout_millsecs: INTEGER
		-- maximum time in milli-seconds the request is allowed to take

	timeout_secs: REAL
		-- maximum time in milli-seconds the request is allowed to take
		do
			Result := timeout_millsecs.to_real / 1000
		end

	timeout_to_connect: INTEGER
		-- The number of seconds to wait while trying to connect. 0 waits indefinitely.

feature -- Access

	error_string: STRING
		do
			if has_error then
				create Result.make_from_c (Curl.error_string (error_code))
			else
				create Result.make_empty
			end
		end

	http_version: DOUBLE

	page_error_code: INTEGER_16
		-- http error code parsed from document page
		local
			bracket_split: EL_SPLIT_ON_CHARACTER_8 [STRING]; sg: EL_STRING_GENERAL_ROUTINES
		do
			if is_html_response then
				create bracket_split.make (last_string, '>')
				across bracket_split as split until Result > 0 loop
					if last_string [split.item_lower].is_digit
						and then attached sg.super_8 (split.item).substring_to (' ') as code_string
					then
						Result := code_string.to_integer_16
					end
				end
			end
		end

	page_error_name: IMMUTABLE_STRING_8
		-- English name for `page_error_code'
		do
			Result := Http_status.name (page_error_code)
		end

	url: EL_URL

	user_agent: STRING

	redirection_url: STRING
		-- redirection location

feature -- Status query

	has_page_error (code: INTEGER_16): BOOLEAN
		do
			Result := page_error_code = code
		end

	has_some_http_error: BOOLEAN
		do
			Result := (400 |..| 510).has (page_error_code.to_integer_32)
		end

	is_certificate_verified: BOOLEAN

	is_host_verified: BOOLEAN

	is_html_response: BOOLEAN
		-- `True' if `last_string' starts with <!DOCTYPE html..
		-- case insensitive
		do
			Result := HTML.is_document (last_string)
		end

	is_open: BOOLEAN
		do
			Result := is_attached (self_ptr)
		end

	is_redirected: BOOLEAN
		do
			Result := redirection_url /= Empty_string_8
		end

	resource_exists (a_url: EL_URL; follow_redirect: BOOLEAN; on_error_action: detachable PROCEDURE [READABLE_STRING_8]): BOOLEAN
		-- `True' if resource exists at `a_url' or else if `follow_redirect = True' and header has redirection location that exists
		-- If `follow_redirect' is false `redirection_url' is set to `last_headers.location'
		-- If `on_error_action' is attached, call routine with any error message
		local
			error_message: detachable STRING
		do
			open_url (a_url)
			read_string_head
			close
			if has_error then
				lio.put_line (error_string)
				error_message := error_string

			elseif attached last_headers as headers then
				if Http_status.redirection_codes.has (headers.response_code) then
					if headers.location.count > 0 and follow_redirect then
						Result := resource_exists (headers.location, False, on_error_action)

					elseif headers.location.is_empty then
						error_message := "Moved but no new location given"
					else
						redirection_url := headers.location
						error_message := "Moved to: " + headers.location
					end

				elseif headers.response_code /= Http_status.ok or else not valid_mime_type (a_url, headers.mime_type) then
					lio.put_labeled_string ("response", headers.response_message)
					lio.put_string_field (" content type", headers.content_type)
					lio.put_new_line
					error_message := headers.response_message
				else
					lio.put_labeled_string ("Request", "OK")
					lio.put_labeled_string (" Type", headers.content_type)
					if headers.content_length > 0 then
						lio.put_integer_field (" Content length", headers.content_length)
					end
					lio.put_new_line
					Result := True
				end
			end
			if attached error_message as message and then attached on_error_action as on_error then
				on_error (message)
			end
		end

feature -- HTTP error status

	is_gateway_timeout: BOOLEAN
		do
			 Result := has_page_error (Http_status.gateway_timeout)
		end

	is_service_unavailable: BOOLEAN
		do
			Result := has_page_error (Http_status.service_unavailable)
		end

feature -- Basic operations

	close
		-- write any cookies if `cookie_store_path' is set and closes connection
		do
			url.wipe_out
			request_headers.wipe_out; post_data_count := 0
			if post_data.count > Max_post_data_count then
				post_data.resize (Max_post_data_count)
			end
			post_data.item.memory_set (0, post_data.count)
			dispose

			close_listener.notify_tick -- Used with `EL_MODULE_TRACK' to track progress of `open', `close' cycles

		-- Workaround for a weird bug where a second call to read_string would hang

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
			open_url (create {EL_URL}.make_from_general (a_url))
		end

	open_url (a_url: EL_URL)
		do
			open_with_parameters (a_url, Void)
		ensure
			opened: is_open
		end

	open_with_parameters (a_url: EL_URL; parameter_table: like new_parameter_table)
		do
			reset
			make_from_pointer (Curl.new_pointer)
			set_url_with_parameters (a_url, parameter_table)
			set_curl_boolean_option (CURLOPT_verbose, False)
			if not user_agent.is_empty then
				set_curl_string_8_option (CURLOPT_useragent, user_agent)
			end
			if timeout_millsecs.to_boolean then
				set_curl_integer_option (CURLOPT_timeout_ms, timeout_millsecs)
			end
			if timeout_to_connect.to_boolean then
				set_curl_integer_option (CURLOPT_connect_timeout, timeout_to_connect)
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

	set_silent_output
		do
			create {EL_SILENT_LOG} lio.make
		end

feature -- Status change

	remove_user_agent
		do
			create user_agent.make_empty
			if is_open then
				set_curl_string_8_option (CURLOPT_useragent, user_agent)
			end
		end

	reset
		do
			last_string.wipe_out
			url.wipe_out
			post_data_count := 0
			error_code := 0
			redirection_url := Empty_string_8
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

	set_http_version (version: INTEGER)
		require
			valid_version: (<< 1_0, 1_1 >>).has (version)
		local
			option: INTEGER
		do
			http_version := version
			inspect version
				when 1_0 then
					option := curl_http_version_1_0
				when 1_1 then
					option := curl_http_version_1_1
			else
				option := curl_http_version_none
				http_version := 0
			end
			set_curl_integer_option (CURLOPT_http_version, option)
		end

	set_log_output (log: EL_LOGGABLE)
		do
			lio := log
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

	set_timeout (millisecs: INTEGER)
		-- set maximum time in milli-seconds the request is allowed to take
		do
			timeout_millsecs := millisecs
		end

	set_timeout_seconds (seconds: REAL)
		-- set maximum time in seconds the request is allowed to take
		do
			timeout_millsecs := (seconds * 1000).rounded
		end

	set_timeout_to_connect (seconds: INTEGER)
		--
		do
			timeout_to_connect := seconds
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
				set_certificate_verification (is_certificate_verified)
				set_hostname_verification (is_host_verified)
			end
		end

	set_user_agent (a_user_agent: STRING)
		do
			user_agent := a_user_agent
			if is_open then
				set_curl_string_8_option (CURLOPT_useragent, a_user_agent)
			end
		end

feature -- SSL settings

	set_certificate_authority_info (cacert_path: FILE_PATH)
		do
			set_curl_string_option (CURLOPT_cainfo, cacert_path)
		end

	set_certificate_verification (flag: BOOLEAN)
		-- Curl verifies whether the certificate is authentic,
		-- i.e. that you can trust that the server is who the certificate says it is.
		do
			set_curl_boolean_option (CURLOPT_ssl_verifypeer, flag)
		end

	set_hostname_verification (flag: BOOLEAN)
		-- If the site you're connecting to uses a different host name that what
		-- they have mentioned in their server certificate's commonName (or
		-- subjectAltName) fields, libcurl will refuse to connect.
		do
			set_curl_boolean_option (CURLOPT_ssl_verifyhost, flag)
		end

	set_tls_version (version: INTEGER)
		require
			valid_unix_version: {PLATFORM}.is_unix implies (<< 0, 1_0, 1_1, 1_2 >>).has (version)
			valid_windows_version: {PLATFORM}.is_windows implies 0 = version
		local
			option: INTEGER
		do
			inspect version
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

	set_tls_version_1_x
		do
			set_curl_integer_option (CURLOPT_sslversion, curl_sslversion_TLSv1)
		end

	set_version (version: INTEGER)
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
feature {NONE} -- Disposal

	c_free (this: POINTER)
		--
		do
			if not is_in_final_collect then
				Curl.clean_up (self_ptr)
			end
		end

end