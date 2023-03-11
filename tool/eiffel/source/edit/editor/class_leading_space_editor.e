note
	description: "Convert lines with leading spaces to tabs or remove them entirely"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 9:36:19 GMT (Friday 10th March 2023)"
	revision: "3"

class
	CLASS_LEADING_SPACE_EDITOR

inherit
	EL_STRING_8_OCCURRENCE_EDITOR
		rename
			count as leading_space_count,
			target as source_text
		export
			{NONE} all
			{ANY} source_text, leading_space_count
		end

create
	make_empty

feature -- Element change

	set_source_text (text: STRING)
		local
			i, j, start_index, end_index: INTEGER
		do
			fill_by_string (text, Newline_space, 0)

--			expand initial leading spaces to include all leading spaces
			if attached area_v2 as a and then attached source_text as source then
				from until i = a.count loop
					start_index := a [i + 1]
					from j := start_index + 1 until j > source.count or else source [j] /= ' ' loop
						 j := j + 1
					end
					end_index := j - 1
					a [i + 1] := end_index
					i := i + 2
				end
			end
		end

feature -- Basic operations

	replace_spaces
		do
			apply (agent replace_leading_spaces)
		end

feature {NONE} -- Implementation

	replace_leading_spaces (input, output: STRING_8; start_index, end_index: INTEGER)
		local
			next_i, space_count, space_count_plus_1, tab_count: INTEGER; s: EL_STRING_8_ROUTINES
		do
			next_i := end_index + 1
			space_count := end_index - start_index
			space_count_plus_1 := space_count + 1
			output.append_character ('%N')
			if space_count_plus_1 \\ 3 = 0 then
				tab_count := space_count_plus_1 // 3
			else
				tab_count := space_count // 3
			end
			if tab_count > 0 then
				output.append (s.n_character_string ('%T', tab_count))
			end
		end

feature {NONE} -- Constants

	Newline_space: STRING = "%N "

end