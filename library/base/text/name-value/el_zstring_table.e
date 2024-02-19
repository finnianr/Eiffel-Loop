note
	description: "[
		Table of ${EL_ZSTRING} strings with keys of type ${STRING_8} and createable from
		parsed general text with format
		
			key_1:
				Value One Line 1
				Value One Line 2
				..
			key_2:
				Value Two
				etc
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-17 17:35:43 GMT (Saturday 17th February 2024)"
	revision: "16"

class
	EL_ZSTRING_TABLE

inherit
	EL_HASH_TABLE [ZSTRING, STRING]
		rename
			make as make_from_array
		end

	EL_STRING_GENERAL_ROUTINES

create
	make, make_size, make_from_array

feature {NONE} -- Initialization

	make (general: READABLE_STRING_GENERAL)
		do
			make_equal (general.occurrences (':'))
			across as_zstring (general).split ('%N') as split loop
				add_line (split.item_copy)
			end
		end

feature -- Access

	name_list: EL_STRING_8_LIST
		do
			create Result.make_from_array (current_keys)
		end

feature {NONE} -- Implementation

	add_line (line: ZSTRING)
		local
			text: ZSTRING; l_count: INTEGER; first, last: CHARACTER_32
		do
			line.right_adjust
			l_count := line.count
			if l_count > 0 then
				first := line [1]
				last := line [l_count]
			end
			if l_count > 1 and then first /= '%T' and last = ':' and line.occurrences (' ') = 0 then
				line.remove_tail (1)
				put (create {ZSTRING}.make_empty, line.twin)
			else
				if first = '%T' then
					line.remove_head (1)
				end
				if inserted then
					text := found_item
					text.grow (text.count + l_count + 1)
					if text.count > 0 then
						text.append_character ('%N')
					end
					text.append (line)
				end
			end
		end
end