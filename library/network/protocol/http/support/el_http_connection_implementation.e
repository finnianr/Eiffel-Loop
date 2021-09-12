note
	description: "Implementation routines for class [$source EL_HTTP_CONNECTION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-12 12:24:02 GMT (Sunday 12th September 2021)"
	revision: "1"

deferred class
	EL_HTTP_CONNECTION_IMPLEMENTATION

inherit
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

	EL_MODULE_LIO

	EL_MODULE_URI

	STRING_HANDLER

	EL_SHARED_CURL_API

	EL_SHARED_HTTP_STATUS

	EL_SHARED_UTF_8_ZCODEC

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

	set_certificate_authority_info (cacert_path: EL_FILE_PATH)
		do
			set_curl_string_option (CURLOPT_cainfo, cacert_path)
		end

	set_curl_boolean_option (a_option: INTEGER; flag: BOOLEAN)
		do
			Curl.setopt_integer (self_ptr, a_option, flag.to_integer)
		end

	set_curl_option_with_data (a_option: INTEGER; a_data_ptr: POINTER)
		do
			Curl.setopt_void_star (self_ptr, a_option, a_data_ptr)
		end

	set_curl_integer_option (a_option: INTEGER; option: INTEGER)
		do
			Curl.setopt_integer (self_ptr, a_option, option)
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

	last_headers: EL_HTTP_HEADERS
		do
			create Result.make (last_string)
		end

	new_parameter_table: detachable HASH_TABLE [READABLE_STRING_GENERAL, READABLE_STRING_GENERAL]
		do
			create {HASH_TABLE [STRING, STRING]} Result.make (0)
		end

feature {NONE} -- Implementation attributes

	post_data: MANAGED_POINTER

	post_data_count: INTEGER

feature {NONE} -- Deferred

	self_ptr: POINTER
		deferred
		end

	last_string: STRING
		deferred
		end

feature {NONE} -- Constants

	Doctype_declaration: STRING = "<!DOCTYPE"

	Max_post_data_count: INTEGER = 1024

	Title_tag: STRING = "<title>"

end