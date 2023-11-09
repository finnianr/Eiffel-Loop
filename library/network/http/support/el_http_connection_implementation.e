note
	description: "Implementation routines for class [$source EL_HTTP_CONNECTION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-09 9:15:17 GMT (Thursday 9th November 2023)"
	revision: "12"

deferred class
	EL_HTTP_CONNECTION_IMPLEMENTATION

inherit
	EL_C_API_ROUTINES

	EL_CURL_OPTION_CONSTANTS
		export
			{NONE} all
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

	STRING_HANDLER

	EL_MODULE_LIO; EL_MODULE_TUPLE; EL_MODULE_URI

	EL_SHARED_CURL_API; EL_SHARED_HTTP_STATUS; EL_SHARED_STRING_8_BUFFER_SCOPES

	EL_SHARED_PROGRESS_LISTENER
		rename
			progress_listener as close_listener,
			is_progress_tracking as is_close_tracking,
			Progress_listener_cell as Close_listener_cell
		end

feature {NONE} -- Initialization

	make
		do
			create last_string.make_empty
			create http_response.make_empty
			create request_headers.make_equal (0)
			create post_data.make (0)
		end

feature -- Access

	cookie_load_path: detachable FILE_PATH

	cookie_store_path: detachable FILE_PATH

	error_code: INTEGER
		-- curl error code

	last_headers: EL_HTTP_HEADERS
		do
			create Result.make (last_string)
		end

	last_string: STRING

feature -- Status query

	has_error: BOOLEAN
		-- `True' if CURL operation returned with an error
		do
			Result := error_code /= 0
		end

feature -- Basic operations

	put_error (log: EL_LOGGABLE)
		require
			has_error: has_error
		do
			log.put_labeled_substitution ("CURL ERROR", "%S %S", [error_code, error_string])
			log.put_new_line
		end

feature {EL_HTTP_COMMAND} -- Implementation

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

	set_certificate_authority_info (cacert_path: FILE_PATH)
		do
			set_curl_string_option (CURLOPT_cainfo, cacert_path)
		end

	set_curl_boolean_option (a_option: INTEGER; flag: BOOLEAN)
		do
			Curl.setopt_integer (self_ptr, a_option, flag.to_integer)
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
			across String_8_scope as scope loop
				Curl.setopt_string (self_ptr, a_option, scope.copied_utf_8_item (string))
			end
		end

	set_curl_string_8_option (a_option: INTEGER; string: STRING)
		do
			Curl.setopt_string (self_ptr, a_option, string)
		end

	set_curl_string_option (a_option: INTEGER; string: ZSTRING)
		do
			across String_8_scope as scope loop
				Curl.setopt_string (self_ptr, a_option, scope.copied_utf_8_item (string))
			end
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

	content: ZSTRING
		do
			create Result.make_from_utf_8 (last_string)
		end

	new_parameter_table: detachable HASH_TABLE [READABLE_STRING_GENERAL, READABLE_STRING_GENERAL]
		do
			create {HASH_TABLE [STRING, STRING]} Result.make (0)
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

	do_command (command: EL_DOWNLOAD_HTTP_COMMAND)
		do
			if is_lio_enabled then
				lio.put_labeled_string ("Sending " + command.type + " request", url)
			end
			command.execute
			if is_lio_enabled then
				lio.put_new_line
			end
			if attached {EL_STRING_DOWNLOAD_HTTP_COMMAND} command as string_download then
				if has_error then
					last_string.wipe_out
				else
					last_string.share (string_download.string)
				end
			end
		end

	do_transfer
			-- do data transfer to/from host
		local
			string_list: POINTER
		do
			string_list := request_headers.to_curl_string_list
			if is_attached (string_list) then
				set_curl_option_with_data (CURLOPT_httpheader, string_list)
			end
			error_code := Curl.perform (self_ptr)
			if is_attached (string_list) then
				curl.free_string_list (string_list)
			end
			if has_error and then is_lio_enabled then
				put_error (lio)
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

	url_extension (a_url: EL_URL): STRING
		local
			dot_index: INTEGER
		do
			dot_index := a_url.last_index_of ('.', a_url.count)
			if dot_index > 0 then
				create Result.make (a_url.count - dot_index)
				Result.append_substring (a_url, dot_index + 1, a_url.count)
				Result.to_lower
			else
				create Result.make_empty
			end
		end

	valid_mime_type (a_url: EL_URL; mime_type: STRING): BOOLEAN
		local
			extension: STRING
		do
			extension := url_extension (a_url)
			if extension ~ once "jpg" then
				extension.insert_character ('e', 3)
			end
			if Image_types.has (extension) then
				Result := mime_type ~ Mime.image + extension
			else
				Result := mime_type.starts_with (Mime.text)
			end
		end

feature {NONE} -- Implementation attributes

	request_headers: EL_CURL_HEADER_TABLE
		-- request headers to send

	http_response: CURL_STRING

	post_data: MANAGED_POINTER

	post_data_count: INTEGER

feature {NONE} -- Deferred

	error_string: STRING
		deferred
		end

	is_html_response: BOOLEAN
		-- `True' if `last_string' is html
		deferred
		end

	self_ptr: POINTER
		deferred
		end

	url: EL_URL
		deferred
		end

feature {NONE} -- Constants

	Image_types: EL_STRING_8_LIST
		once
			Result := "gif, png, jpeg"
		end

	Mime: TUPLE [image, text: STRING]
		once
			create Result
			Tuple.fill (Result, "image/, text/")
		end

	Max_post_data_count: INTEGER = 1024

end