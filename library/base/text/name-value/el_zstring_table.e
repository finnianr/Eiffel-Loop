note
	description: "[
		Table of [$source EL_ZSTRING] strings with keys of type [$source STRING_8] and createable from
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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-26 13:22:58 GMT (Friday 26th November 2021)"
	revision: "8"

class
	EL_ZSTRING_TABLE

inherit
	HASH_TABLE [ZSTRING, STRING]
		rename
			make as make_with_count
		end

create
	make, make_with_count

feature {NONE} -- Initialization

	make (general: READABLE_STRING_GENERAL)
		local
			s: EL_ZSTRING_ROUTINES; text: ZSTRING
		do
			make_equal (general.occurrences (':'))
			across s.as_zstring (general).split ('%N') as split loop
				add_line (split.item_copy)
			end
		end

feature {NONE} -- Implementation

	add_line (line: ZSTRING)
		local
			text: ZSTRING
		do
			line.right_adjust
			if line.count > 0 then
				if line [1] = '%T' then
					line.remove_head (1)
					if inserted then
						text := found_item
						text.grow (text.count + line.count + 1)
						if text.count > 0 then
							text.append_character ('%N')
						end
						text.append (line)
					end
				elseif line [line.count] = ':' then
					line.remove_tail (1)
					put (create {ZSTRING}.make_empty, line.twin)
				end
			end
		end
end