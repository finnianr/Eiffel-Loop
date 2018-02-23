note
	description: "Reads obsolete `EL_ASTRING' data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_ASTRING_READER

feature -- Access

	read_as_string_32 (a_reader: EL_MEMORY_READER_WRITER): STRING_32
		local
			foreign_characters: SPECIAL [NATURAL]
			i, foreign_count, l_index, l_count: INTEGER; code: NATURAL
		do
			Result := a_reader.read_string_8
			foreign_count := a_reader.read_integer_32
			if foreign_count > 0 then
				create foreign_characters.make_filled (0, foreign_count)
				from i := 0 until i = foreign_count loop
					foreign_characters [i] := a_reader.read_compressed_natural_32
					i := i + 1
				end
				l_count := Result.count
				from i := 1 until i > l_count loop
					code := Result.code (i)
					if is_place_holder_item (code) then
						l_index := index (code)
						if l_index <= foreign_count then
							Result.put_code (foreign_characters [l_index - 1], i)
						end
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	is_place_holder_item (code: NATURAL): BOOLEAN
		do
			inspect code
				when 1 .. 8, 14 .. 31 then
					Result := True
			else
			end
		end

	index (a_place_holder: NATURAL): INTEGER
		do
			Result := a_place_holder.to_integer_32
			if a_place_holder > 8 then
				Result := Result - 5
			end
		end
end
