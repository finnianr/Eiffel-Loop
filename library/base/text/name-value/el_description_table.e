note
	description: "[
		Table of descriptions parsed from text with format
		
			key_1:
				Description One
			key_2:
				Description Two
				etc
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-17 12:18:15 GMT (Thursday 17th September 2020)"
	revision: "1"

class
	EL_DESCRIPTION_TABLE

inherit
	HASH_TABLE [ZSTRING, STRING]
		rename
			make as make_table
		end

	EL_ZSTRING_CONSTANTS

	EL_MODULE_ZSTRING

create
	make

feature {NONE} -- Initialization

	make (general: READABLE_STRING_GENERAL)
		local
			text: ZSTRING
		do
			make_equal (general.occurrences (':'))
			text := Zstring.to (general)
			text.do_with_splits (character_string ('%N'), agent add_line)
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