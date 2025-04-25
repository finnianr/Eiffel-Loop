note
	description: "Fcgi servlet response"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 7:22:51 GMT (Friday 25th April 2025)"
	revision: "38"

class
	FCGI_SERVLET_RESPONSE

inherit
	SINGLE_MATH

	FCGI_SHARED_HEADER

	EL_SHARED_DOCUMENT_TYPES; EL_SHARED_HTTP_STATUS; EL_SHARED_STRING_8_BUFFER_POOL

	EL_SHARED_UTF_8_ZCODEC

	EL_SHARED_DOCUMENT_TYPES
		export
			{ANY} Text_type
		end

	EL_STRING_8_CONSTANTS

	EL_ENCODING_TYPE
		export
			{NONE} all
		end

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

	status: INTEGER_16
		-- The result status that will be send with this response.

	status_message: STRING
		-- The status message
		do
			create Result.make (30)
			Result.append_integer_16 (status)
			Result.append_character (' ')
			Result.append (Http_status.name (status))
		end

feature -- Status query

	is_head_request: BOOLEAN
		do
			Result := broker.is_head_request
		end

	is_encoded: BOOLEAN
		-- `True' if `content' is already encoded as `content_type.encoding'

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
			Result := attached {READABLE_STRING_8} content
		end

feature -- Basic operations

	send
		-- send response headers and content
		local
			buffer, content_buffer: STRING
		do
			if not is_sent then
				content_buffer := encoded_content

				set_header (Header.status, status_message)
				set_header (Header.content_length, content_buffer.count.out)
				set_header (Header.content_type, content_type.specification)
				set_header (Header.x_powered_by, Powered_by)

				if status = Http_status.ok then
					set_cookie_headers
				end
				if attached String_8_pool.biggest_item as borrowed then
					buffer := borrowed.empty
					header_list.sort_by_key (True)
					if attached header_list as list then
						from list.start until list.after loop
							buffer.append (Header.name (list.item_key)); buffer.append (Colon_space)
							buffer.append (list.item_value)
							buffer.append (Carriage_return_new_line)
							list.forth
						end
					end
					buffer.append (Carriage_return_new_line) -- This is required even for HEAD requests

					if not is_head_request then
						buffer.append (content_buffer)
					end

					broker.write_stdout (buffer)
					borrowed.return
				end
				write_ok := broker.write_ok
				if write_ok then
					content_length := content_buffer.count
				end
				is_sent := True
			end
		end

	send_error (sc: like status; message: READABLE_STRING_GENERAL; doc_type: NATURAL_8; encoding: NATURAL)
			-- Send an error response to the client using the specified
			-- status code and descriptive message. The server generally
			-- creates the response to look like a normal server error page.
		require
			valid_type_and_encoding: Text_type.valid_value (doc_type)
		local
			code_name: IMMUTABLE_STRING_8; html: ZSTRING
		do
			code_name := Http_status.name (sc)
			content_type := document_type (doc_type, encoding)
			if doc_type = Text_type.html then
				html := Error_page_template #$ [code_name, code_name, message]
				if content_type.encoding.is_utf_encoded then
					content := html.to_utf_8
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
			content_type := document_type (Text_type.plain, Latin_1)
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

	set_encoded_content (text: READABLE_STRING_8; type: EL_DOC_TYPE)
		-- set 8-bit content that is already encode as `type.encoding'
		require
			valid_utf_8: type.is_utf_8_encoded implies is_valid_utf_8_string_8 (text)
		do
			content := text; content_type := type
			is_encoded := True
		end

	set_content (text: READABLE_STRING_GENERAL; doc_type: NATURAL_8; encoding: NATURAL)
		require
			valid_type_and_encoding: Text_type.valid_value (doc_type)
		do
			if text.is_string_8 and then encoding = Latin_1
				and then attached {READABLE_STRING_8} text as encoded_text
			then
				set_encoded_content (encoded_text, document_type (doc_type, encoding))
			else
				content := text; set_content_type (document_type (doc_type, encoding))
				is_encoded := False
			end
		end

	set_content_ok
		do
			content_type := document_type (Text_type.plain, Latin_1)
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
			if is_encoded and then attached {READABLE_STRING_8} content as encoded then
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

	header_list: EL_ARRAYED_MAP_LIST [NATURAL_8, STRING]
		-- list of mappings: header enumeration code -> value

feature {NONE} -- Constants

	Carriage_return_new_line: STRING = "%R%N"

	Colon_space: STRING = ": "

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

	Powered_by: STRING = "Eiffel-Loop Fast-CGI servlets"

end