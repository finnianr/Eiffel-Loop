note
	description: "Summary description for {FCGI_SERVLET_RESPONSE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-05 15:20:40 GMT (Sunday 5th November 2017)"
	revision: "1"

class
	FCGI_SERVLET_RESPONSE

inherit
	EL_HTTP_CONTENT_TYPE_CONSTANTS

	EL_SHARED_ZCODEC_FACTORY

	EL_MODULE_UTF

	EL_MODULE_HTTP_STATUS

create
	make

feature {NONE}-- Initialization

	make (fcgi_request: FCGI_REQUEST)
			-- Build a new Fast CGI response object that provides access to
			-- 'fcgi_request' information.
			-- Initialise the response information to allow a successful (Sc_ok) response
			-- to be sent immediately.
		do
			internal_request := fcgi_request
			create cookies.make (5)
			create headers.make (5)
			create content_buffer.make_empty
			initial_buffer_size := Default_buffer_size
			reset
			write_ok := True
		end

feature -- Access

	socket_error: STRING
			-- A string describing the socket error which occurred
		do
			Result := internal_request.socket_error
		end

	content_length: INTEGER
		-- The length of the content that will be sent with this response.

	status: NATURAL_16
		-- The result status that will be send with this response.

	status_message: STRING
		-- The status message. Void if none.
		do
			Result := Http_status.code_name (status)
		end

feature -- Status query

	is_committed: BOOLEAN
			-- Has the response been committed? A committed response has already
			-- had its status code and headers written.

	is_head_request: BOOLEAN
		do
			Result := internal_request.parameters.is_head_request
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
				write (content_buffer)
			end
		end

feature -- Element change

	reset
			-- Clear any data that exists in the buffer as well as the status code
			-- and headers.
		do
			content_buffer.wipe_out
			cookies.wipe_out
			headers.wipe_out
			set_content_length (0)
			set_content_type ("text/html")
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
			write_error (sc, Http_status.code_name (sc))
		end

	set_content (text: READABLE_STRING_GENERAL; a_type: EL_HTTP_CONTENT_TYPE)
		require
			valid_mixed_encoding: attached {ZSTRING} text as z_text implies
												(not a_type.is_utf_8_encoded implies z_text.has_mixed_encoding)
		local
			str: STRING
		do
			set_content_type (a_type.out)
			if attached {ZSTRING} text as z_text then
				if a_type.is_utf_8_encoded then
					str := z_text.to_utf_8
				else
					str := z_text.as_encoded_8 (new_codec (a_type))
				end
			elseif attached {STRING} text as text_8 then
				str := text_8

			elseif attached {STRING_32} text as text_32 then
				if a_type.is_utf_8_encoded then
					str := UTF.string_32_to_utf_8_string_8 (text_32)
				else
					str := text_32.as_string_8
				end
			else
				create str.make_empty
			end
			content_buffer.wipe_out
			content_buffer.append (str)
		end

	set_content_length (length: INTEGER)
			-- Set the length of the content body in the response.
		do
			content_length := length
			set_header ("Content-Length", length.out)
		end

	set_content_ok
		do
			set_content (once "OK", Content_plain_latin_1)
		end

	set_content_type (type: STRING)
			-- Set hte content type of the response being sent to the client.
			-- The content type may include the type of character encoding used, for
			-- example, 'text/html; charset=ISO-885904'

		do
			if type.substring_index ("charset", 1) = 0 then
				set_header ("Content-Type", type + latin1)
			else
				set_header ("Content-Type", type)
			end
		end

	set_header (name, value: STRING)
			-- Set a response header with the given name and value. If the
			-- header already exists, the new value overwrites the previous
			-- one.
		local
			new_values: like headers.item
		do
			create new_values.make (3)
			new_values.extend (value)
			headers [name] := new_values
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
		local
			new_values: like headers.item
		do
			headers.search (name)
			if headers.found then
				headers.found_item.extend (value)
			else
				create new_values.make (3)
				new_values.extend (value)
				headers [name] := new_values
			end
		end

	build_headers: STRING
			-- Build string representation of headers suitable for sending as a response.			
		local
			header_values: like headers.item
			name: STRING
		do
			create Result.make (200)
			across headers as header loop
				from
					name := header.key
					header_values := header.item
					header_values.start
				until
					header_values.off
				loop
					Result.append_string (name)
					Result.append_string (": ")
					Result.append_string (header_values.item_for_iteration)
					Result.append_string ("%R%N")
					header_values.forth
				end
			end
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
				internal_request.write_stdout (data)
			end
			write_ok := internal_request.write_ok
		end

	write_error (sc: like status; msg: STRING)
			-- Send an error response to the client using the specified
			-- status code and descriptive message. The server generally
			-- creates the response to look like a normal server error page.
		local
			html, code_name: STRING
		do
			code_name := Http_status.code_name (sc)
			html := Error_page_template #$ [code_name, code_name, msg]
			set_status (sc)
			set_content_type ("text/html")
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
			write (build_headers)
			write ("%R%N")
			is_committed := True
		ensure
			is_committed: is_committed
		end

	internal_request: FCGI_REQUEST
		-- Internal request information and stream functionality.

feature {NONE} -- Internal attributes

	Default_buffer_size: INTEGER = 4096
		-- Default size of output buffer

	content_buffer: STRING
		-- Buffer for writing output for response. Not used when error or redirect
		-- pages are sent. Created on demand

	cookies: ARRAYED_LIST [EL_HTTP_COOKIE]
		-- The cookies that will be sent with this response.

	headers: HASH_TABLE [ARRAYED_LIST [STRING], STRING]
		-- The headers that will be sent with this response.

	initial_buffer_size: INTEGER
		-- Size of buffer to create.


feature {NONE} -- Constants

	Expired_date: STRING = "Tue, 01-Jan-1970 00:00:00 GMT"

	Latin1: STRING = "; charset=ISO-8859-1"

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

end
