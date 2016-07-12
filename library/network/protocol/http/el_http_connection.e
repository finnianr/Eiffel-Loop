note
	description: "[
		Object for accessing http content
		
		Note: cookies are not written until close is called
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-09 7:57:58 GMT (Saturday 9th July 2016)"
	revision: "6"

class
	EL_HTTP_CONNECTION

inherit
	CURL_EASY_EXTERNALS
		rename
			cleanup as curl_close,
			init as new_pointer
		export
			{NONE} all
		end

	CURL_OPT_CONSTANTS
		rename
			is_valid as is_valid_opt_constant
		export
			{NONE} all
		end

	CURL_FORM_CONSTANTS
		rename
			is_valid as is_valid_form_constant
		export
			{NONE} all
		end

	EL_C_OBJECT
		rename
			c_free as curl_close
		export
			{NONE} all
		undefine
			curl_close
		redefine
			is_memory_owned, dispose
		end

	EL_MODULE_URL
		rename
			Url as Mod_url
		end

	EL_MODULE_BASE_64
		export
			{NONE} all
		end

	EL_MODULE_CURL
		export
			{NONE} all
		end

	EL_MODULE_LIO
		export
			{NONE} all
		end

	EL_STRING_CONSTANTS

create
	make, make_with_cookie

feature {NONE} -- Initialization

	make
		do
			Curl.initialize
			create cookie_file_path
			create last_string.make_empty
			http_method := CURLOPT_httpget
		end

	make_with_cookie (a_cookie_file_path: like cookie_file_path)
		do
			make
			cookie_file_path := a_cookie_file_path
		end

feature -- Access

	cookie_file_path: EL_FILE_PATH

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
			-- write any cookies and close connection
		do
			url := Empty_string
			dispose
			full_collect -- Workaround for a strange bug where a second call to read_string would hang
		end

	open (a_url: like url)
		do
			if is_lio_enabled then
				lio.put_labeled_string ("open", a_url); lio.put_new_line
			end
			make_from_pointer (new_pointer)
			reset
			if not cookie_file_path.is_empty then
				setopt_string (self_ptr, CURLOPT_cookiejar, cookie_file_path)
				setopt_string (self_ptr, CURLOPT_cookiefile, cookie_file_path)
			end
			set_url (a_url)
		ensure
			opened: is_open
		end

	post_parameters (parameters: EL_HTTP_HASH_TABLE)
		do
			post_raw_parameters_string (parameters.name_value_pairs_string)
		end

	post_raw_parameters_string (raw_string_8: STRING)
		do
			setopt_string (self_ptr, CURLOPT_postfields, raw_string_8)
			http_method := CURLOPT_postfields
			read_string
		end

	read_string
		local
			http_response: CURL_STRING
		do
			create http_response.make_empty
			set_write_function (self_ptr)

--			You must make sure that the data is formatted the way you want the server to receive it.
--			libcurl will not convert or encode it for you in any way. For example, the web server may
--			assume that this data is url-encoded.
			if url.has ('?') then
				set_get_method
			end

			setopt_integer (self_ptr, CURLOPT_writedata, http_response.object_id)
			error_code := perform (self_ptr)
			if has_error then
				lio.put_integer_field ("CURL error code", error_code)
				lio.put_new_line
				last_string.wipe_out
			else
				last_string.share (http_response)
			end
		end

	reset_cookie_session
			-- Mark this as a new cookie "session". It will force libcurl to ignore all cookies it is about to load
			-- that are "session cookies" from the previous session. By default, libcurl always stores and loads all cookies,
			-- independent if they are session cookies or not. Session cookies are cookies without expiry date and they are meant
			-- to be alive and existing for this "session" only.
		require
			cookie_file_path_set: not cookie_file_path.is_empty
		do
			setopt_integer (self_ptr, CURLOPT_cookiesession, 1)
		end

feature -- Status setting

	set_redirection_follow
		do
			setopt_integer (self_ptr, CURLOPT_followlocation, 1)
		end

feature -- Element change

	reset
		do
			last_string.wipe_out
			error_code := 0
		end

	set_cookie_file_path (a_cookie_file_path: like cookie_file_path)
		do
			cookie_file_path := a_cookie_file_path
		end

	set_ssl_certificate_verification (flag: BOOLEAN)
			-- Curl verifies whether the certificate is authentic,
			-- i.e. that you can trust that the server is who the certificate says it is.
		do
			setopt_integer (self_ptr, CURLOPT_ssl_verifypeer, flag.to_integer)
		end

	set_ssl_hostname_verification (flag: BOOLEAN)
			-- If the site you're connecting to uses a different host name that what
     		-- they have mentioned in their server certificate's commonName (or
     		-- subjectAltName) fields, libcurl will refuse to connect.
		do
			setopt_integer (self_ptr, CURLOPT_ssl_verifyhost, flag.to_integer)
		end

	set_timeout (millisecs: INTEGER)
			-- set maximum time in milli-seconds the request is allowed to take
		do
			setopt_integer (self_ptr, CURLOPT_timeout_ms, millisecs)
		end

	set_timeout_seconds (seconds: INTEGER)
			-- set maximum time in seconds the request is allowed to take
		do
			setopt_integer (self_ptr, CURLOPT_timeout, seconds)
		end

	set_timeout_to_connect (seconds: INTEGER)
			--
		do
			setopt_integer (self_ptr, CURLOPT_timeout, seconds)
		end

	set_url (a_url: like url)
		do
			url := a_url
--			Curl already does url encoding
			setopt_string (self_ptr, CURLOPT_url, a_url.to_utf_8)
			set_get_method
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
			setopt_string (self_ptr, {CURL_OPT_CONSTANTS}.CURLOPT_useragent, user_agent)
		end

feature -- Disposal

	dispose
		do
			if is_open then
				curl_close (self_ptr)
				self_ptr := Default_pointer
			end
		end

feature {NONE} -- Experimental

	read_string_experiment
			-- Cannot get this to work
		local
			http_response: CURL_STRING
			form_post, form_last: CURL_FORM
		do
			create form_post.make; create form_last.make
			set_form_parameters (form_post, form_last)

			create http_response.make_empty
			set_write_function (self_ptr)
			setopt_integer (self_ptr, CURLOPT_writedata, http_response.object_id)
			error_code := perform (self_ptr)
			last_string.share (http_response)
		end

	set_form_parameters (form_post, form_last: CURL_FORM)
			-- Haven't worked out how to use this
		do
--			across parameters as parameter loop
--				Curl.formadd_string_string (
--					form_post, form_last,
--					CURLFORM_COPYNAME, parameter.key,
--					CURLFORM_COPYCONTENTS, parameter.item,
--					CURLFORM_END
--				)
--			end
			setopt_form (self_ptr, CURLOPT_httppost, form_post)
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
			status := getinfo (self_ptr, Curlinfo_redirect_url, result_cell)
			if status = 0 then
				Result := result_cell.item
			end
		end

feature {NONE} -- Implementation

	set_get_method
		do
			if http_method /= CURLOPT_httpget then
				setopt_integer (self_ptr, CURLOPT_httpget, 1)
				http_method := CURLOPT_httpget
			end
		end

feature {NONE} -- Implementation attributes

	http_method: INTEGER
		-- POST or GET

	is_memory_owned: BOOLEAN = True

feature {NONE} -- Constants

	Curlinfo_redirect_url: INTEGER
		once
			Result := {CURL_INFO_CONSTANTS}.Curlinfo_string + 31
		end

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

	Title_tag: STRING = "<title>"

	Secure_protocol: ZSTRING
		once
			Result := "https:"
		end

end
