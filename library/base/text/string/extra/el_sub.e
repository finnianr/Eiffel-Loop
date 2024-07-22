note
	description: "[
		Text cell for a substring of a string conforming to ${READABLE_STRING_GENERAL}.
		Intended for use with ${EL_REFLECTIVE_STRING_TABLE}.
	]"
	notes: "[
		Used by class ${EL_REFLECTIVE_STRING_TABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-22 15:33:17 GMT (Monday 22nd July 2024)"
	revision: "1"

class
	EL_SUB [S -> STRING_GENERAL create make end]

inherit
	ANY

	EL_STRING_8_CONSTANTS

create
	make, make_empty

convert
	string: {S}

feature {NONE} -- Initialization

	make_empty
		do
			table_text := Empty_string_8
		end

feature -- Element change

	make, set_string (a_table_text: READABLE_STRING_GENERAL; a_start_index, a_end_index: INTEGER)
		do
			table_text := a_table_text; start_index := a_start_index; end_index := a_end_index
		end

feature -- Access

	count: INTEGER
		-- count of characters omitting leading tab
		local
			rs: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			Result := end_index - start_index
			if attached rs.shared_cursor (table_text) as cursor then
				Result := Result - cursor.occurrences_in_bounds ('%N', start_index + 1, end_index)
			end
		end

	lines: EL_STRING_LIST [S]
		do
			create Result.make_with_lines (new_string)
			Result.unindent (1)
		end

	string, str: S
		-- substring of `table_text' specified by `compact_interval'
		do
			Result := lines.joined_lines
		ensure
			valid_count: Result.count = count
		end

feature {NONE} -- Implementation

	new_string: S
		-- substring of `table_text' specified by `compact_interval'
		do
			if table_text.valid_index (start_index)
				and then end_index >= start_index - 1 and end_index <= table_text.count
			then
				create Result.make (count)
				Result.append_substring (table_text, start_index, end_index)
			else
				create Result.make (0)
			end
		end

feature {NONE} -- Internal attributes

	end_index: INTEGER

	start_index: INTEGER

	table_text: READABLE_STRING_GENERAL

end