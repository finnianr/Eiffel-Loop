note
	description: "Class to substitute spaces for tabs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-06 10:43:23 GMT (Sunday 6th October 2024)"
	revision: "8"

class
	EL_TAB_REMOVER

inherit
	EL_PARSER
		rename
			new_pattern as line_pattern
		redefine
			default_source_text
		end

	TP_FACTORY

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create output_text.make_empty
			set_tab_size (Default_tab_size)
			make_default
		end

feature -- Access

	normalized_text (text: ZSTRING; indent: INTEGER): ZSTRING
			--
		do
			output_text.wipe_out
			indent_tab_count := indent
			encountered_non_blank_line := false
			set_source_text (text)
			unindent_text
			Result := output_text.twin
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

feature -- Basic operations

	unindent_text
		do
			find_all (Void)
		end

feature {NONE} -- Pattern definitions

	line_pattern: like all_of
			--
		do
			Result := all_of (<<
				zero_or_more (character_literal ('%T')) |to| agent on_tabbed_indent,
				while_not_p1_repeat_p2 (
					end_of_line_character, any_character
				) |to| agent on_line (?, ?, output_text)
			>>)
		end

feature {NONE} -- Match actions

	on_line (start_index, end_index: INTEGER; gathered_lines: ZSTRING)
			--
		local
			i, indent_count: INTEGER; line: ZSTRING; skip_line: BOOLEAN
		do
			line_count := line_count + 1
			if line_count = 1 then
				line_1_tab_count := tab_count
			end
			indent_count := indent_tab_count + tab_count - line_1_tab_count
			line := new_source_substring (start_index, end_index)

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

	on_tabbed_indent (start_index, end_index: INTEGER)
			--
		do
			tab_count := end_index - start_index + 1
		end

feature {NONE} -- Implementation

	default_source_text: ZSTRING
		do
			Result := Empty_string
		end

	is_blank_line (line: ZSTRING): BOOLEAN
		local
			i: INTEGER
		do
			Result := True
			from i := 1 until not Result or else i > line.count loop
				if not line.is_space_item (i) then
					Result := False
				end
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	encountered_non_blank_line: BOOLEAN

	indent_tab_count: INTEGER

	line_1_tab_count: INTEGER

	line_count: INTEGER

	output_text: ZSTRING

	skip_blank_lines_at_start: BOOLEAN

	tab_count: INTEGER

	tab_spaces: ZSTRING

feature {NONE} -- Constants

	Default_tab_size: INTEGER = 4
			-- Space count

end