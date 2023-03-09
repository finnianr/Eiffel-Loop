note
	description: "Convert lines with leading spaces to tabs or remove them entirely"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-09 10:46:26 GMT (Thursday 9th March 2023)"
	revision: "2"

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
			next_i, space_count: INTEGER; s: EL_STRING_8_ROUTINES
		do
			next_i := end_index + 1
			space_count := end_index - start_index
			output.append_character ('%N')
			if next_i <= input.count and then input [next_i] = '%T' then
				do_nothing

			elseif space_count >= 3 then
				output.append (s.n_character_string ('%T', tab_count (space_count)))
			end
		end

	tab_count (a_space_count: INTEGER): INTEGER
		local
			space_count, divisor: INTEGER; divisible: BOOLEAN
		do
			space_count := a_space_count
			from until divisible or space_count = 0 loop
				from divisor := 3 until divisible or divisor > 4 loop
					if space_count \\ divisor = 0 then
						divisible := True
					else
						divisor := divisor + 1
					end
				end
				if not divisible then
					space_count := space_count - 1
				end
			end
			Result := space_count // divisor
		end

feature {NONE} -- Constants

	Newline_space: STRING = "%N "

end