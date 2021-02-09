note
	description: "Fcgi servlet response"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-09 13:10:16 GMT (Tuesday 9th February 2021)"
	revision: "24"

class
	FCGI_SERVLET_RESPONSE

inherit
	SINGLE_MATH

	EL_SHARED_DOCUMENT_TYPES

	EL_SHARED_HTTP_STATUS

	EL_SHARED_UTF_8_ZCODEC

	EL_STRING_8_CONSTANTS

	FCGI_SHARED_HEADER

create
	make

feature {NONE}-- Initialization

	make (a_broker: FCGI_REQUEST_BROKER)
			-- Build a new Fast CGI response object that provides access to
			-- 'broker' information.
			-- Initialise the response information to allow a successful (Sc_ok) response
			-- to be sent immediately.
		do
			broker := a_broker
			create cookie_list.make (5)
			create header_list.make (5)
			reset
		end

feature -- Access

	content_length: INTEGER
		-- the sent header length for `content'

	content_type: EL_DOC_TYPE

	socket_error: STRING
			-- A string describing the socket error which occurred
		do
			Result := broker.socket_error
		end

	status: NATURAL_16
		-- The result status that will be send with this response.

	status_message: STRING
		-- The status message
		do
			create Result.make (30)
			Result.append_natural_16 (status)
			Result.append_character (' ')
			Result.append (Http_status.name (status))
		end

feature -- Status query

	is_head_request: BOOLEAN
		do
			Result := broker.is_head_request
		end

	is_encoded: BOOLEAN
		-- `True' if content is encoded

	is_sent: BOOLEAN
			-- `True' when response has already had it's status code and headers written.

	write_ok: BOOLEAN
			-- Was there a problem sending the data to the client?

feature -- Contract Support

	is_valid_utf_8_string_8 (s: READABLE_STRING_8): BOOLEAN
		local
			c: EL_UTF_CONVERTER
		do
			Result := c.is_valid_utf_8_string_8 (s)
		end

	is_string_8_content: BOOLEAN
		do
			Result := attached {STRING} content
		end

feature -- Basic operations

	send
		-- send response headers and content
		local
			list: like header_list; buffer, content_buffer: STRING
			string_8_buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			if not is_sent then
				content_buffer := encoded_content

				set_header (Header.server, once "Eiffel-Loop FCGI servlet")
				set_header (Header.status, status_message)
				set_header (Header.content_length, content_buffer.count.out)
				set_header (Header.content_type, content_type.specification)

				if status = Http_status.ok then
					set_cookie_headers
				end
				buffer := string_8_buffer.empty
				list := header_list
				list.sort (True)
				from list.start until list.after loop
					buffer.append (Header.name (list.item.key)); buffer.append (once ": ")
					buffer.append (list.item.value)
					buffer.append (Carriage_return_new_line)
					list.forth
				end
				buffer.append (Carriage_return_new_line) -- This is required even for HEAD requests

				if not is_head_request then
					buffer.append (content_buffer)
				end
				broker.write_stdout (buffer)
				write_ok := broker.write_ok
				if write_ok then
					content_length := content_buffer.count
				end
				is_sent := True
			end
		end

	send_error (sc: like status; message: READABLE_STRING_GENERAL; a_content_type: EL_DOC_TYPE)
			-- Send an error response to the client using the specified
			-- status code and descriptive message. The server generally
			-- creates the response to look like a normal server error page.
		local
			code_name: STRING; html: ZSTRING
		do
			code_name := Http_status.name (sc)
			content_type := a_content_type
			if a_content_type.type ~ once "html" then
				html := Error_page_template #$ [code_name, code_name, message]
				if a_content_type.encoding.is_utf_encoded then
					content := html.to_utf_8 (True)
				else
					content := html.to_latin_1
				end
			else
				content := message.to_string_8
			end
			set_status (sc)
			send
		end

feature -- Element change

	reset
			-- Clear any data that exists in the buffer as well as the status code
			-- and headers.
		do
			cookie_list.wipe_out
			header_list.wipe_out
			content := Empty_string_8
			content_type := Doc_type_plain_latin_1
			content_length := 0
			set_status (Http_status.ok)
			write_ok := False
			is_sent := False
		end

	send_as_cookies (object: EL_COOKIE_SETTABLE)
		do
			send_cookies (object.cookie_list)
		end

	send_cookie (name, value: STRING)
		do
			cookie_list.extend (create {EL_HTTP_COOKIE}.make (name, value))
		end

	send_cookies (a_cookie_list: ITERABLE [EL_HTTP_COOKIE])
		do
			across a_cookie_list as cookie loop
				cookie_list.extend (cookie.item)
			end
		end

	set_encoded_content (text: STRING; type: EL_DOC_TYPE)
		require
			valid_utf_8: type.encoding.encoded_as_utf (8) implies is_valid_utf_8_string_8 (text)
		do
			content := text; content_type := type
			is_encoded := True
		end

	set_content (text: READABLE_STRING_GENERAL; type: EL_DOC_TYPE)
		do
			if type.encoding.encoded_as_latin (1) and then attached {STRING} text as encoded_text then
				set_encoded_content (encoded_text, type)
			else
				content := text; content_type := type
				is_encoded := False
			end
		end

	set_content_ok
		do
			content_type := Doc_type_plain_latin_1
			content := once "OK"
		end

	set_content_type (type: EL_DOC_TYPE)
		-- set content type of the response being sent to the client.
		do
			content_type := type
		end

	set_header (header_enum: NATURAL_8; value: STRING)
			-- Set a response header with the given name and value. If the
			-- header already exists, the new value overwrites the previous
			-- one.
		do
			header_list.set_key_item (header_enum, value)
		end

	set_status (a_status: like status)
			-- Set the status code for this response. This method is used to
			-- set the return status code when there is no error (for example,
			-- for the status codes Sc_ok or Sc_moved_temporarily). If there
			-- is an error, the 'send_error' method should be used instead.
		do
			status := a_status
		end

feature {NONE} -- Implementation

	add_header (header_enum: NATURAL_8; value: STRING)
			-- Adds a response header with the given `header_enum' and value. This
			-- method allows response headers to have multiple values.
		do
			header_list.extend (header_enum, value)
		end

	encoded_content: STRING
		local
			buffer: like Encoding_buffer
		do
			if is_encoded and then attached {STRING} content as encoded then
				Result := encoded
			else
				buffer := Encoding_buffer
				buffer.wipe_out
				buffer.set_encoding_from_other (content_type.encoding)
				buffer.put_string_general (content)
				Result := buffer.text
			end
		end

	set_cookie_headers
			-- Add 'Set-Cookie' header for cookies. Add a separate 'Set-Cookie' header
			-- for each new cookie.
			-- Also add cookie caching directive headers.
		do
			if not cookie_list.is_empty then
				across cookie_list as cookie loop
					add_header (Header.set_cookie, cookie.item.header_string)
				end
				-- add cache control headers for cookie management
				add_header (Header.cache_control, once "no-cache=%"Set-Cookie%"")
				set_header (Header.expires, Expired_date)
			end
		end

feature {FCGI_SERVLET_REQUEST} -- Internal attributes

	broker: FCGI_REQUEST_BROKER
		-- broker to read and write request messages from the web server

	content: READABLE_STRING_GENERAL

feature {NONE} -- Internal attributes

	cookie_list: ARRAYED_LIST [EL_HTTP_COOKIE]
		-- The cookie_list that will be sent with this response.

	header_list: EL_KEY_SORTABLE_ARRAYED_MAP_LIST [NATURAL_8, STRING]
		-- list of mappings: header enumeration code -> value

feature {NONE} -- Constants

	Carriage_return_new_line: STRING = "%R%N"

	Encoding_buffer: EL_STRING_8_IO_MEDIUM
		once
			create Result.make (0)
		end

	Error_page_template: ZSTRING
		once
			Result := "[
				<html>
					<head>
						<title>#</title>
					</head>
					<body>
						<center><h1>#</h1></center>
						<p>#</p>
					</body>
				</html>
			]"
		end

	Expired_date: STRING = "Tue, 01-Jan-1970 00:00:00 GMT"

end