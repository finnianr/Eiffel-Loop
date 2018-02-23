note
	description: "Summary description for {FCGI_SERVLET_RESPONSE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-05 10:56:13 GMT (Monday 5th February 2018)"
	revision: "4"

class
	FCGI_SERVLET_RESPONSE

inherit
	EL_HTTP_CONTENT_TYPE_CONSTANTS

	EL_MODULE_HTTP_STATUS

	EL_STRING_CONSTANTS

	SINGLE_MATH

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
			create cookies.make (5)
			create header_list.make (5)
			create content_buffer.make (0)
			initial_buffer_size := Default_buffer_size
			reset
			write_ok := True
		end

feature -- Access

	content_length: INTEGER
		-- The length of the content that will be sent with this response.

	socket_error: STRING
			-- A string describing the socket error which occurred
		do
			Result := broker.socket_error
		end

	status: NATURAL_16
		-- The result status that will be send with this response.

	status_message: STRING
		-- The status message. Void if none.
		do
			Result := Http_status.name (status)
		end

feature -- Status query

	is_committed: BOOLEAN
			-- Has the response been committed? A committed response has already
			-- had its status code and headers written.

	is_head_request: BOOLEAN
		do
			Result := broker.is_head_request
		end

	write_ok: BOOLEAN
			-- Was there a problem sending the data to the client?

feature -- Basic operations

	flush_buffer
		do
			if not is_committed then
				set_content_length (content_buffer.count)
				write_headers
				is_committed := True
			end
			if not is_head_request and not content_buffer.is_empty then
				write (content_buffer.text)
			end
		end

feature -- Element change

	reset
			-- Clear any data that exists in the buffer as well as the status code
			-- and headers.
		do
			content_buffer.wipe_out
			cookies.wipe_out
			header_list.wipe_out
			content_length := 0
			set_content_type (Content_plain_latin_1)
			set_status (Http_status.ok)
			is_committed := False
		end

	send_cookie (name, value: STRING)
		do
			cookies.extend (create {EL_HTTP_COOKIE}.make (name, value))
		end

	send_error (sc: like status)
			-- Send an error response to the client using the specified
			-- status code. The server generally creates the response to
			-- look like a normal server error page.
		do
			write_error (sc, Http_status.name (sc))
		end

	set_content (text: READABLE_STRING_GENERAL; type: EL_HTTP_CONTENT_TYPE)
		require
			valid_mixed_encoding: attached {ZSTRING} text as z_text implies
												(not type.is_utf_encoding (8) implies z_text.has_mixed_encoding)
		do
			set_content_type (type)
			content_buffer.wipe_out
			content_buffer.put_string_general (text)
		end

	set_content_length (length: INTEGER)
			-- Set the length of the content body in the response.
		local
			header: STRING
		do
			content_length := length
			create header.make (Header_content_length.count + log10 (length).rounded.min (1))
			header.append (Header_content_length)
			header.append_integer (length)
			header_list.extend (header)
		end

	set_content_ok
		do
			set_content (once "OK", Content_plain_latin_1)
		end

	set_content_type (type: EL_HTTP_CONTENT_TYPE)
			-- set content type of the response being sent to the client.
			-- The content type may include the type of character encoding used, for
			-- example, 'text/html; charset=ISO-8859-15'

		do
			set_header (once "Content-Type", type.specification)
			content_buffer.set_encoding_from_other (type)
		end

	set_content_utf_8 (utf_8_text: STRING)
		-- set `content_buffer' with pre-encoded `utf_8_text'
		do
			set_content_type (Content_html_utf_8)
			content_buffer.wipe_out
			content_buffer.put_raw_string_8 (utf_8_text)
		end

	set_header (name, value: STRING)
			-- Set a response header with the given name and value. If the
			-- header already exists, the new value overwrites the previous
			-- one.
		local
			list: like header_list; found: BOOLEAN
			header: STRING
		do
			list := header_list
			from list.start until found or list.after loop
				header := list.item
				if header.starts_with (name) and then header [name.count + 1] = ':' then
					list.replace (new_header (name, value))
					found := True
				end
				list.forth
			end
			if not found then
				list.extend (new_header (name, value))
			end
		end

	set_status (a_status: like status)
			-- Set the status code for this response. This method is used to
			-- set the return status code when there is no error (for example,
			-- for the status codes Sc_ok or Sc_moved_temporarily). If there
			-- is an error, the 'send_error' method should be used instead.
		do
			status := a_status
		end

feature {FCGI_SERVLET_REQUEST} -- Implementation

	add_header (name, value: STRING)
			-- Adds a response header with the given naem and value. This
			-- method allows response headers to have multiple values.
		do
			header_list.extend (new_header (name, value))
		end

	broker: FCGI_REQUEST_BROKER
		-- broker to read and write request messages from the web server

	new_header (name, value: STRING): STRING
		do
			create Result.make (2 + name.count + value.count)
			Result.append (name)
			Result.append (once ": ")
			Result.append (value)
		end

	set_cookie_headers
			-- Add 'Set-Cookie' header for cookies. Add a separate 'Set-Cookie' header
			-- for each new cookie.
			-- Also add cookie caching directive headers.
		do
			if not cookies.is_empty then
				across cookies as cookie loop
					add_header ("Set-Cookie", cookie.item.header_string)
				end
				-- add cache control headers for cookie management
				add_header ("Cache-control", "no-cache=%"Set-Cookie%"")
				set_header ("Expires", Expired_date)
			end
		end

	set_default_headers
			-- Set default headers for all responses including the Server and Date headers.	
		do
		end

	write (data: STRING)
			-- Write 'data' to the output stream for this response
		do
			if write_ok then
				broker.write_stdout (data)
			end
			write_ok := broker.write_ok
		end

	write_error (sc: like status; msg: STRING)
			-- Send an error response to the client using the specified
			-- status code and descriptive message. The server generally
			-- creates the response to look like a normal server error page.
		local
			html, code_name: STRING
		do
			code_name := Http_status.name (sc)
			html := Error_page_template #$ [code_name, code_name, msg]
			set_status (sc)
			set_content_type (Content_plain_latin_1)
			set_content_length (html.count)
			write_headers
			write (html)
		end

	write_headers
			-- Write the response headers to the output stream.
		require
			not_committed: not is_committed
		do
			-- NOTE: There is no need to send the HTTP status line because
			-- the FastCGI protocol does it for us.
			set_default_headers
			set_cookie_headers

			header_list.sort
			header_list.extend (Empty_string_8)
			header_list.extend (Empty_string_8)
			write (header_list.joined_with_string (once "%R%N"))

			is_committed := True
		ensure
			is_committed: is_committed
		end

feature {NONE} -- Internal attributes

	Default_buffer_size: INTEGER = 4096
		-- Default size of output buffer

	content_buffer: EL_STRING_8_IO_MEDIUM
		-- Buffer for writing output for response. Not used when error or redirect
		-- pages are sent. Created on demand

	cookies: ARRAYED_LIST [EL_HTTP_COOKIE]
		-- The cookies that will be sent with this response.

	header_list: EL_STRING_8_LIST

	initial_buffer_size: INTEGER
		-- Size of buffer to create.

feature {NONE} -- Constants

	Header_content_length: STRING = "Content-Length: "

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
