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
	date: "2025-11-15 15:28:15 GMT (Saturday 15th November 2025)"
	revision: "65"

class
	EL_HTTP_CONNECTION

inherit
	EL_HTTP_CONNECTION_OPTIONS

create
	make

feature {NONE} -- Initialization

	make
		do
			curl := Default_curl
			create url.make_empty
			create user_agent.make_empty
			cert_verification := True
			host_verification := True
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
			Result := curl.error_string
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

	redirection_url: STRING
		-- redirection location

	user_agent: STRING

feature -- Status query

	cert_verification: EL_BOOLEAN_OPTION
		-- should certificates be verified for https

	has_page_error (code: INTEGER_16): BOOLEAN
		do
			Result := page_error_code = code
		end

	has_some_http_error: BOOLEAN
		do
			Result := (400 |..| 510).has (page_error_code.to_integer_32)
		end

	host_verification: EL_BOOLEAN_OPTION
		-- should host name be verified for https

	is_html_response: BOOLEAN
		-- `True' if `last_string' starts with <!DOCTYPE html..
		-- case insensitive
		do
			Result := HTML.is_document (last_string)
		end

	is_open: BOOLEAN
		do
			Result := not curl.is_default
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
			set_certificate_authority_info_default
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
			cert_verification := True; host_verification := True

			curl.close; curl := Default_curl

			close_listener.notify_tick -- Used with `EL_MODULE_TRACK' to track progress of `open', `close' cycles

		-- Workaround for a weird bug where a second call to read_string would hang

		-- September 2016: It's possible this weird bug might have been resolved by the rewrite of code
		-- handling cURL C callbacks that happened in this month.
		end

	open (a_url: READABLE_STRING_GENERAL)
		do
			open_url (create {EL_URL}.make_from_general (a_url))
		end

	open_url (a_url: EL_URL)
		do
			open_with_parameters (a_url, Empty_parameter_table)
		ensure
			opened: is_open
		end

	open_with_parameters (a_url: EL_URL; a_parameter_table: like PARAMETER_TABLE)
		do
			reset
			create curl.make (lio, timeout_millsecs, timeout_to_connect, user_agent)
			set_url_with_parameters (a_url, a_parameter_table)
		ensure
			opened: is_open
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

feature -- Status change

	remove_user_agent
		do
			create user_agent.make_empty
			if is_open then
				curl.set_string_8_option (CURLOPT_useragent, user_agent)
			end
		end

	reset
		do
			url.wipe_out
			curl.reset
			redirection_url := Empty_string_8
		end

	set_silent_output
		do
			create {EL_SILENT_LOG} lio.make
		end

feature -- Status change

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
			is_open: is_open
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
			curl.set_integer_option (CURLOPT_http_version, option)
		end

	set_log_output (log: EL_LOGGABLE)
		do
			lio := log
		end

	set_post_parameters (parameters: EL_URI_QUERY_ZSTRING_HASH_TABLE)
		require
			is_open: is_open
		do
			curl.set_post_data (parameters.query_string (True, False))
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

	set_url_with_parameters (a_url: EL_URL; a_parameter_table: like PARAMETER_TABLE)
		require
			is_open: is_open
		do
			url.wipe_out
			url.append (a_url)
			url.append_query_from_table (a_parameter_table)
--			Curl already does url encoding
			curl.set_string_8_option (CURLOPT_url, url)
		-- Essential calls for using https
			if url.is_https then
				set_certificate_verification (cert_verification.is_enabled)
				set_hostname_verification (host_verification.is_enabled)
			end
		end

	set_user_agent (a_user_agent: STRING)
		do
			user_agent := a_user_agent
			if is_open then
				curl.set_string_8_option (CURLOPT_useragent, a_user_agent)
			end
		end

end