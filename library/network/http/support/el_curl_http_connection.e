note
	description: "HTTP connection using the curl API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-15 15:28:08 GMT (Saturday 15th November 2025)"
	revision: "2"

class
	EL_CURL_HTTP_CONNECTION

inherit
	EL_OWNED_C_OBJECT
		export
			{NONE} all
		end

	EL_CURL_INFO_CONSTANTS
		export
			{NONE} all
		end

	EL_CURL_OPTION_CONSTANTS
		export
			{NONE} all
		end

	EL_CURL_PLATFORM_SSL_CONSTANTS
		export
			{NONE} all
		end

	EL_CURL_SSL_CONSTANTS
		export
			{NONE} all
		end

	EL_SHARED_CURL_API

create
	make, make_default

feature {NONE} -- Initialization

	make (a_lio: EL_LOGGABLE; timeout_millsecs, timeout_to_connect: INTEGER; user_agent: STRING)
		do
			make_default
			make_from_pointer (Curl.new_pointer)
			lio := a_lio
			set_boolean_option (CURLOPT_verbose, False)
			if not user_agent.is_empty then
				set_string_8_option (CURLOPT_useragent, user_agent)
			end
			if timeout_millsecs.to_boolean then
				set_integer_option (CURLOPT_timeout_ms, timeout_millsecs)
			end
			if timeout_to_connect.to_boolean then
				set_integer_option (CURLOPT_connect_timeout, timeout_to_connect)
			end
		end

	make_default
		do
			create last_string.make_empty
			create post_data.make (0)
			create request_headers.make_equal (0)
			create http_response.make_empty
			create {EL_SILENT_LOG} lio.make
		end

feature -- Access

	error_code: INTEGER
		-- curl error code

	error_string: STRING
		do
			if has_error then
				create Result.make_from_c (Curl.error_string (error_code))
			else
				create Result.make_empty
			end
		end

	last_string: STRING

feature -- Status query

	has_error: BOOLEAN
		-- `True' if CURL operation returned with an error
		do
			Result := error_code /= 0
		end

	is_default: BOOLEAN
		-- `True' if connection not initialized
		do
			Result := self_ptr.is_default_pointer
		end

feature -- Element change

	clear_error
		do
			error_code := 0
		end

	set_last_string (a_last_string: STRING)
		do
			last_string := a_last_string
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

feature -- Basic operations

	close
		-- write any cookies if `cookie_store_path' is set and closes connection
		do
			post_data_count := 0
			if post_data.count > Max_post_data_count then
				post_data.resize (Max_post_data_count)
			end
			post_data.item.memory_set (0, post_data.count)
			request_headers.wipe_out
			dispose
		end

	put_error (log: EL_LOGGABLE)
		require
			has_error: has_error
		do
			log.put_labeled_substitution ("CURL ERROR", "%S %S", [error_code, error_string])
			log.put_new_line
		end

feature -- SSL settings

	set_ssl_version (version: INTEGER)
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
			set_integer_option (CURLOPT_sslversion, option)
		end

	set_tls_version (version: INTEGER)
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
			set_integer_option (CURLOPT_sslversion, option)
		end

	set_tls_version_1_x
		do
			set_integer_option (CURLOPT_sslversion, curl_sslversion_TLSv1)
		end

feature -- Status change

	enable_get_method
		do
			set_boolean_option (CURLOPT_httpget, True)
			set_boolean_option (CURLOPT_post, False)
		end

	enable_post_method
		do
			set_boolean_option (CURLOPT_httpget, False)
			set_boolean_option (CURLOPT_post, True)
			if post_data.count > 0 then
				set_option_with_data (CURLOPT_postfields, post_data.item)
				set_integer_option (CURLOPT_postfieldsize, post_data_count)
			end
		end

	set_nobody (flag: BOOLEAN)
		do
			set_boolean_option (CURLOPT_nobody, flag)
		end

	put_request_header (key, value: STRING)
		do
			request_headers [key] := value
		end

	reset
		do
			post_data_count := 0
			error_code := 0
			last_string.wipe_out
		end

	set_boolean_option (a_option: INTEGER; flag: BOOLEAN)
		do
			Curl.setopt_integer (self_ptr, a_option, flag.to_integer)
		end

	set_header_function (callback, user_data: POINTER)
		do
			set_option_with_data (CURLOPT_headerfunction, callback)
			set_option_with_data (CURLOPT_headerdata, user_data)
		end

	set_integer_option (a_option: INTEGER; option: INTEGER)
		do
			Curl.setopt_integer (self_ptr, a_option, option)
		end

	set_option_with_data (a_option: INTEGER; a_data_ptr: POINTER)
		do
			Curl.setopt_void_star (self_ptr, a_option, a_data_ptr)
		end

	set_string_32_option (a_option: INTEGER; string: READABLE_STRING_32)
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			Curl.setopt_string (self_ptr, a_option, utf_8.string_32_to_string_8 (string))
		end

	set_string_8_option (a_option: INTEGER; string: STRING)
		do
			Curl.setopt_string (self_ptr, a_option, string)
		end

	set_string_option (a_option: INTEGER; string: ZSTRING)
		do
			set_string_32_option (a_option, string)
		end

	set_write_function (callback, user_data: POINTER)
		do
			set_option_with_data (CURLOPT_writefunction, callback)
			set_option_with_data (CURLOPT_writedata, user_data)
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
			set_integer_option (CURLOPT_writedata, http_response.object_id)
			error_code := Curl.perform (self_ptr)
			last_string.share (http_response)
		end

	redirect_url: STRING
		-- Fails because Curlinfo_redirect_url will not satisfy contract CURL_INFO_CONSTANTS.is_valid
		-- For some reason Curlinfo_redirect_url is missing from CURL_INFO_CONSTANTS
		require
			no_error: not has_error
		local
			result_cell: CELL [STRING]; status: INTEGER
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
			string_list := request_headers.to_curl_string_list
			if is_attached (string_list) then
				set_option_with_data (CURLOPT_httpheader, string_list)
			end
			error_code := Curl.perform (self_ptr)
			if is_attached (string_list) then
				curl.free_string_list (string_list)
			end
			if has_error then
				put_error (lio)
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

feature {EL_HTTP_COMMAND} -- Internal attributes

	http_response: CURL_STRING

	lio: EL_LOGGABLE

	post_data: MANAGED_POINTER

	post_data_count: INTEGER

	request_headers: EL_CURL_HEADER_TABLE
		-- request headers to send

feature {NONE} -- Constants

	Max_post_data_count: INTEGER = 1024

end