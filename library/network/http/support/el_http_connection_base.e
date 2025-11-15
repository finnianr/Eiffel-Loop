note
	description: "Implementation routines for class ${EL_HTTP_CONNECTION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-15 12:15:16 GMT (Saturday 15th November 2025)"
	revision: "25"

deferred class
	EL_HTTP_CONNECTION_BASE

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_HTML; EL_MODULE_TUPLE; EL_MODULE_URI

	EL_CURL_OPTION_CONSTANTS
		export
			{NONE} all
		end

	EL_STRING_8_CONSTANTS

	EL_SHARED_HTTP_STATUS

	EL_SHARED_PROGRESS_LISTENER
		rename
			progress_listener as close_listener,
			is_progress_tracking as is_close_tracking,
			Progress_listener_cell as Close_listener_cell
		end

	EL_STRING_HANDLER

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
		do
			Result := curl.last_string
		end

	url: EL_URL

feature -- Status query

	has_error: BOOLEAN
		-- `True' if CURL operation returned with an error
		do
			Result := curl.has_error
		end

feature -- Basic operations

	download (file_path: FILE_PATH)
		-- save document downloaded using the HTTP GET command
		do
			do_command (create {EL_FILE_DOWNLOAD_HTTP_COMMAND}.make (Current, file_path))
		end

	put_error (log: EL_LOGGABLE)
		require
			has_error: has_error
		do
			curl.put_error (log)
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

feature {NONE} -- Implementation

	content: ZSTRING
		do
			create Result.make_from_utf_8 (last_string)
		end

feature {EL_HTTP_COMMAND} -- Implementation

	do_command (command: EL_DOWNLOAD_HTTP_COMMAND)
		do
			lio.put_labeled_string ("Sending " + command.type + " request", url)
			lio.put_new_line
			command.execute
			lio.put_line ("Sent")
			if attached {EL_STRING_DOWNLOAD_HTTP_COMMAND} command as string_download then
				if has_error then
					last_string.wipe_out
				else
					last_string.share (string_download.string)
				end
			end
		end

	set_cookie_options
		do
			if attached cookie_store_path as store_path then
				curl.set_string_option (CURLOPT_cookiejar, store_path)
			end
			if attached cookie_load_path as load_path then
				curl.set_string_option (CURLOPT_cookiefile, load_path)
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

feature {EL_HTTP_COMMAND} -- Implementation attributes

	curl: EL_CURL_HTTP_CONNECTION

	lio: EL_LOGGABLE

feature {NONE} -- Type definitions

	PARAMETER_TABLE: HASH_TABLE [READABLE_STRING_GENERAL, READABLE_STRING_GENERAL]
		require
			never_called: False
		once
			Result := Empty_parameter_table
		end

feature {NONE} -- Constants

	Default_curl: EL_CURL_HTTP_CONNECTION
		once ("PROCESS")
			create Result.make_default
		end

	Empty_parameter_table: EL_HASH_TABLE [STRING, STRING]
		once
			create Result.make (0)
		end

	Image_types: EL_STRING_8_LIST
		once
			Result := "gif, png, jpeg"
		end

	Mime: TUPLE [image, text: STRING]
		once
			create Result
			Tuple.fill (Result, "image/, text/")
		end

end