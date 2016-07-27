note
	description: "Summary description for {EL_HTTP_SERVLET_RESPONSE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-31 12:53:53 GMT (Sunday 31st January 2016)"
	revision: "7"

class
	EL_HTTP_SERVLET_RESPONSE

inherit
	GOA_FAST_CGI_SERVLET_RESPONSE
		export
			{EL_HTTP_SERVLET} content_length
		redefine
			make, flush_buffer, set_default_headers
		end

	EL_MODULE_UTF

	EL_SHARED_ZCODEC_FACTORY

	EL_HTTP_CONTENT_TYPE_CONSTANTS

create
	make

feature {NONE}-- Initialization

	make (fcgi_request: GOA_FAST_CGI_REQUEST)
		do
			fcgi_request.parameters.search ({GOA_CGI_VARIABLES}.Request_method_var)
			if fcgi_request.parameters.found then
				is_head_request := Method_head ~ fcgi_request.parameters.found_item
			end
			Precursor (fcgi_request)
		end

feature -- Status query

	is_head_request: BOOLEAN

feature -- Element change

	set_default_headers
			-- Set default headers for all responses including the Server and Date headers.	
		do
		end

	set_content (text: READABLE_STRING_GENERAL; a_type: EL_HTTP_CONTENT_TYPE)
		require
			valid_mixed_encoding: attached {ZSTRING} text as z_text implies
												(not a_type.is_utf_8_encoded implies z_text.has_mixed_encoding)
		do
			set_content_type (a_type.out)
			if attached {ZSTRING} text as z_text then
				if a_type.is_utf_8_encoded then
					content_buffer := z_text.to_utf_8
				else
					content_buffer := z_text.as_encoded_8 (new_codec (a_type))
				end

			elseif attached {STRING} text as text_8 then
				content_buffer := text_8

			elseif attached {STRING_32} text as text_32 then
				if a_type.is_utf_8_encoded then
					content_buffer := UTF.string_32_to_utf_8_string_8 (text_32)
				else
					content_buffer := text_32.as_string_8
				end
			end
		end

	set_content_ok
		do
			set_content (once "OK", Content_plain_latin_1)
		end

feature -- Basic operations

	flush_buffer
		do
			if content_buffer = Void then
				content_buffer := ""
			end
			if not is_committed then
				set_content_length (content_buffer.count)
				write_headers
				is_committed := True
			end
			if not is_head_request and not content_buffer.is_empty then
				write (content_buffer)
			end
		end

	send_cookie (name, value: STRING)
		do
			add_cookie (create {GOA_COOKIE}.make (name, value))
		end

feature {NONE} -- Constants

	Method_head: STRING = "HEAD"

end