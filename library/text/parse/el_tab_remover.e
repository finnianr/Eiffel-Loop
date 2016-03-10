note
	description: "Class to substitute spaces for tabs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	EL_TAB_REMOVER

inherit
	EL_PARSER
		rename
			new_pattern as line_pattern
		end

	EL_MODULE_LOG

	EL_TEXTUAL_PATTERN_FACTORY

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			create output_text.make_empty
			set_tab_size (Default_tab_size)
		end

feature -- Access

	normalized_text (text: ASTRING; indent: INTEGER): ASTRING
			--
		do
			output_text.wipe_out
			indent_tab_count := indent
			encountered_non_blank_line := false
			set_source_text (text)
			find_all
			consume_events
			create Result.make_from_other (output_text)
		end

feature -- Element change

	set_tab_size (n: INTEGER)
			--
		do
			create tab_spaces.make_filled (' ', n)
		end

feature -- Status setting

	ignore_leading_blank_lines
			--
		do
			skip_blank_lines_at_start := true
		end

feature {NONE} -- Pattern definitions

	line_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				zero_or_more (character_literal ('%T')) |to| agent on_tabbed_indent,
				while_not_pattern_1_repeat_pattern_2 (
					end_of_line_character, any_character
				) |to| agent on_line (?, output_text)
			>>)
		end

feature {NONE} -- Match actions

	on_tabbed_indent (line_match: EL_STRING_VIEW)
			--
		do
			tab_count := line_match.count
		end

	on_line (line_match: EL_STRING_VIEW; gathered_lines: ASTRING)
			--
		local
			i, indent_count: INTEGER
			line: ASTRING
			skip_line: BOOLEAN
		do
			line_count := line_count + 1
			if line_count = 1 then
				line_1_tab_count := tab_count
			end
			indent_count := indent_tab_count + tab_count - line_1_tab_count
			line := line_match

			if skip_blank_lines_at_start then
				if not encountered_non_blank_line and then is_blank_line (line) then
					skip_line := true
				else
					encountered_non_blank_line := true
				end
			end

			if not skip_line then
				from i := 1 until i > indent_count loop
					gathered_lines.append (tab_spaces)
					i := i + 1
				end
				gathered_lines.append (line)
			end
		end

feature {NONE} -- Implementation

	unindent_text
			--
		do
			find_all
			consume_events
		end

	is_blank_line (line: STRING): BOOLEAN
			--
		do
			Result := across line as l_char all l_char.item.is_space end
		end

	indent_tab_count: INTEGER

	output_text: ASTRING

	line_count: INTEGER

	tab_count: INTEGER

	line_1_tab_count: INTEGER

	tab_spaces: STRING

	encountered_non_blank_line: BOOLEAN

	skip_blank_lines_at_start: BOOLEAN

feature {NONE} -- Constants

	Default_tab_size: INTEGER = 4
			-- Space count

end
