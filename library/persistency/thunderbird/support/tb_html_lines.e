note
	description: "Thunderbird HTML content lines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-14 15:19:02 GMT (Tuesday 14th February 2023)"
	revision: "2"

class
	TB_HTML_LINES

inherit
	EL_ZSTRING_LIST
		rename
			make as make_sized
		end

	EL_STRING_STATE_MACHINE [ZSTRING]
		rename
			traverse as do_with_lines,
			make as make_machine
		undefine
			copy, is_equal
		end

	TB_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (content_lines: EL_ZSTRING_LIST)
		do
			make_sized (content_lines.count)
			do_with_lines (agent append_html_line, content_lines)
		end

feature {NONE} -- State handlers

	append_html_line (line: ZSTRING)
		local
			last_line: ZSTRING
		do
			if line_included (line) then
				-- Correct lines like:
				-- <h2 class="first">Introduction<br/>
				-- </h2>
				if is_heading (line) and then not is_empty then
					line.left_adjust
					last_line := last
					if last_line.ends_with (Tag.break.open) then
						last_line.replace_substring (line, last_line.count - Tag.break.open.count + 1 , last_line.count)
					else
						last_line.append (line)
					end
				else
					extend (line)
				end
			end
		end

feature {NONE} -- Implementation

	is_heading (line: ZSTRING): BOOLEAN
		-- when true `line' is a heading
		do
			Result := across Heading_levels as level some
				line.begins_with (header_tag (level.item).close)
			end
		end

	line_included (line: ZSTRING): BOOLEAN
		-- when true `line' is added to `html_lines'
		do
			Result := True
		end

	is_empty_tag_line (line: ZSTRING): BOOLEAN
		-- True if line conforms to string pattern:
		-- 	[white space][open tag][white space][corresponding closing tag]
		-- For example: "    <p> </p>"
		-- (Useful in redefinition of `line_included')

		local
			bracket_intervals: like intervals
			right_bracket_pos: INTEGER; s: EL_ZSTRING_ROUTINES
		do
			bracket_intervals := intervals (line, s.character_string ('<'))
			if bracket_intervals.count = 2
				and then line.is_substring_whitespace (1, bracket_intervals.first_lower - 1)
				and then line.same_characters (Tag_close_start, 1, 2, bracket_intervals.last_lower)
				and then line.ends_with_character ('>')
			then
				right_bracket_pos := line.index_of ('>', bracket_intervals.first_lower + 1)
				if right_bracket_pos > 0
					and then right_bracket_pos < bracket_intervals.last_lower
					and then line.is_substring_whitespace (right_bracket_pos + 1, bracket_intervals.last_lower - 1)
				then
					-- True if left and right tag names are the same
					Result := line.same_characters (
						line, bracket_intervals.first_lower + 1, right_bracket_pos - 1, bracket_intervals.first_lower + 1
					)
				end
			end
		end

end