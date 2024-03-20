note
	description: "Error description line list with ID"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-20 10:36:32 GMT (Wednesday 20th March 2024)"
	revision: "8"

class
	EL_ERROR_DESCRIPTION

inherit
	EL_ZSTRING_LIST
		rename
			make as make_list,
			count as line_count,
			first as first_line,
			last as last_line,
			item as line
		export
			{NONE} all
			{ANY} extend, first_line, last_line, append, append_sequence,
				line_count, line, new_cursor, forth, start, after
		redefine
			initialize
		end

	EL_STRING_8_CONSTANTS

create
	make, make_code, make_empty, make_with_lines, make_from_array

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			code := 0; id := Empty_string_8
		end

	make (a_id: like id)
		do
			make_empty
			id := a_id
		end

	make_code (a_code: INTEGER)
		do
			make_empty
			code := a_code
		end

feature -- Access

	code: INTEGER
		-- return code

	id: READABLE_STRING_GENERAL

feature -- Element change

	set_code (a_code: INTEGER)
		do
			code := a_code
		end

	set_id (a_id: like id)
		do
			id := a_id
		end

	set_lines (a_string: READABLE_STRING_GENERAL)
		do
			wipe_out
			append_split (a_string, '%N', 0)
		end

	set_list (a_list: ARRAYED_LIST [ZSTRING])
		do
			area_v2 := a_list.area
		end

feature -- Basic operations

	print_to (log: EL_LOGGABLE)
		do
			if id.count > 0 then
				log.put_labeled_string ("ERROR", id)
				log.put_new_line
			end
			across Current as list loop
				log.put_line (list.item)
			end
		end

end