note
	description: "Summary description for {WEB_PAGE_PROPERTIES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 20:06:11 GMT (Friday 8th July 2016)"
	revision: "1"

class
	WEB_PAGE_PROPERTIES

inherit
	EL_XPATH_ROOT_NODE_CONTEXT
		redefine
			make_from_file
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		undefine
			default_create
		end

create
	make_from_file

feature {NONE} -- Initaliazation

	make_from_file (file_path: EL_FILE_PATH)
			--
		do
			make_machine
			create lines.make_empty
			do_once_with_file_lines (agent find_html_tag, create {EL_FILE_LINE_SOURCE}.make (file_path))
			lines.extend ("</html>")
			lio.put_string_field_to_max_length ("XML", lines.joined_lines, 200)
			lio.put_new_line
			make_from_string (lines.joined_lines)
			lines.wipe_out
		end

feature {NONE} -- Line procedure transitions

	find_body_tag (line: ZSTRING)
			--
		do
			line.left_adjust
			lines.extend (line)
			if line.starts_with (Meta_tag) then
				line.insert_character ('/', line.count)

			elseif line.starts_with (Body_tag) then
				state := agent find_end_of_body_attributes
				find_end_of_body_attributes (line)
			end
		end

	find_end_of_body_attributes (line: ZSTRING)
			--
		do
			if lines.last /= line then
				lines.extend (line)
			end
			if line.ends_with (Right_bracket) then
				line.insert_character ('/', line.count)
				state := agent final
			end
		end

	find_html_tag (line: ZSTRING)
			--
		do
			if line.starts_with (Html_open_tag) then
				lines.extend (line)
				state := agent find_body_tag
			end
		end

feature {NONE} -- Implementation

	lines: EL_LINKED_STRING_LIST [ZSTRING]
		-- Header lines

feature {NONE} -- Constants

	Body_tag: ZSTRING
		once
			Result := "<body"
		end

	Html_open_tag: ZSTRING
		once
			Result := "<html>"
		end

	Meta_tag: ZSTRING
		once
			Result := "<meta"
		end

	Right_bracket: ZSTRING
		once
			Result := ">"
		end
end