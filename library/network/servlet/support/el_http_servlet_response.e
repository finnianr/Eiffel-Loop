note
	description: "Summary description for {EL_HTTP_SERVLET_RESPONSE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-10-02 9:43:04 GMT (Thursday 2nd October 2014)"
	revision: "5"

class
	EL_HTTP_SERVLET_RESPONSE

inherit
	GOA_FAST_CGI_SERVLET_RESPONSE
		redefine
			default_create, send
		end

	EL_MODULE_UTF
		undefine
			default_create
		end

	EL_MODULE_LOG
		undefine
			default_create
		end

create
	make, default_create

feature {NONE} -- Initialization

	default_create
		do
			create content_buffer.make_empty
			create cookies.make_default
			create headers.make_default
			create internal_request.make
			create status_message.make_empty
		end

feature -- Basic operations

	send_ok
		do
			send_latin_1_plain ("OK")
		end

	send_latin_1_plain (text: STRING)
			-- send latin-1 encoded plain text
		do
			send_text (text, Encoding_latin_1, Text_type_plain)
		end

	send_utf8_xml (text: READABLE_STRING_GENERAL)
		do
			send_utf8_text (text, "xml")
		end

	send_utf8_plain (text: READABLE_STRING_GENERAL)
		do
			send_utf8_text (text, Text_type_plain)
		end

	send_utf8_html (text: READABLE_STRING_GENERAL)
		do
			send_utf8_text (text, "html")
		end

	send_utf8_text (text: READABLE_STRING_GENERAL; type: STRING)
		require
			valid_encoding: attached {STRING} text as utf8_str and then not attached {ASTRING} utf8_str
				implies UTF.is_valid_utf_8_string_8 (utf8_str)
		local
			utf8: STRING
		do
			if attached {ASTRING} text as astring then
				utf8 := astring.to_utf8
			elseif attached {STRING} text as utf8_text then
				utf8 := utf8_text
			end
			set_content_type (Mime_type_template #$ [type, "UTF-8"])
			send (utf8)
		end

	send (data: STRING)
		do
			log.enter_no_header (once "send")
			log.put_integer_field (once "Sending bytes", data.count)
			log.put_new_line
			set_content_length (data.count)
			Precursor (data)
			log.exit_no_trailer
		end

	send_cookie (name, value: STRING)
		do
			add_cookie (create {GOA_COOKIE}.make (name, value))
		end

	send_html (text: ASTRING; encoding_name: STRING)
		do
			send_text (text, encoding_name, "html")
		end

	send_text (text: ASTRING; encoding_name, type: STRING)
		require
			no_foreign_encodings: not text.has_foreign_characters
		do
			set_content_type (Mime_type_template #$ [type, encoding_name])
			send (text.to_string_8)
		end

feature {NONE} -- Constants

	Mime_type_template: ASTRING
		once
			Result := "text/$S; charset=$S"
		end

	Text_type_plain: STRING = "plain"

	Encoding_latin_1: STRING = "ISO-8859-1"

end
