note
	description: "[
		insert string:
			<rect x="0" y="0" width="x" height="x" style="fill:#FFFFFF"/> 
		after 'svg' open tag.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:34:59 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_SVG_BACKGROUND_COLOR_INSERTER

inherit
	PLAIN_TEXT_FILE
		rename
			make as make_file
		export
			{NONE} all
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (input_file_path, output_file_path: EL_FILE_PATH)
			--
		do
			make_open_write (output_file_path)
			create width_attribute.make_empty
			create height_attribute.make_empty
			do_with_lines_from_file (agent initial, input_file_path)
			close
		end

feature {NONE} -- Line handlers

	initial (line: STRING)
			--
		do
			line_procedure := agent find_svg
			find_svg (line)
		end

	find_svg (line: STRING)
			--
		do
			put_string (line); new_line
			if line.starts_with ("<svg") then
				line_procedure := agent find_closing_bracket
			end
		end

	find_closing_bracket (line: STRING)
			--
		local
			trim_line: STRING
		do
			put_string (line); new_line
			trim_line := trim (line)
			if trim_line.starts_with ("width") then
				width_attribute := trim_line

			elseif trim_line.starts_with ("height") then
				height_attribute := trim_line

			end
			if line.ends_with (">") then
				put_string ("<rect x=%"0%" y=%"0%" ")
				put_string (width_attribute)
				put_character (' ')
				put_string (height_attribute)
				put_string (" style=%"fill:#FFFFFF%"/>")
				new_line
				line_procedure := agent find_end
			end
		end

	find_end (line: STRING)
			--
		do
			put_string (line); new_line
		end

feature {NONE} -- Implementation

	width_attribute: STRING

	height_attribute: STRING

	trim (line: STRING): STRING
		do
			Result := line.string
			Result.left_adjust
		end

end
