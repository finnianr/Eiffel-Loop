note
	description: "Summary description for {THUNDERBIRD_MAIL_TO_HTML_BODY_CONVERTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 19:58:29 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	THUNDERBIRD_MAIL_TO_HTML_BODY_CONVERTER

inherit
	THUNDERBIRD_MAIL_CONVERTER
		rename
			find_start as find_body
		redefine
			make, write_html
		end

create
	make

feature {NONE} -- Initialization

	make (a_output_dir: EL_DIR_PATH)
			--
		do
			Precursor (a_output_dir)
			break_tag := XML.open_tag ("br")
		end

feature {NONE} -- State handlers

	find_body (line: EL_ASTRING)
		do
			if trim_line.starts_with ("<body") then
				state := agent find_right_angle_bracket
				find_right_angle_bracket (line)
			end
		end

	find_right_angle_bracket (line: EL_ASTRING)
		do
			if trim_line [trim_line.count] = '>' then
				state := agent find_end_tag (?, "</body>")
			end
		end

feature {NONE} -- Implementation

	write_html
		do
			html.finish; html.remove
			from html.finish until not trimmed_line_is_break_tag (html.item) loop
				html.remove
				html.finish
			end
			Precursor
		end

	write_line (line: EL_ASTRING; file_out: PLAIN_TEXT_FILE)
		do
			line.remove_head (4)
			file_out.put_string (line)
			file_out.put_new_line
		end

	trimmed_line_is_break_tag (line: EL_ASTRING): BOOLEAN
		local
			l_line: EL_ASTRING
		do
			l_line := line.twin
			l_line.left_adjust
			Result := l_line.same_string (break_tag)
		end

	file_out_extension: EL_ASTRING
		do
			Result := "body"
		end

	space_entity: IMMUTABLE_STRING_8

feature {NONE} -- Constants


end
