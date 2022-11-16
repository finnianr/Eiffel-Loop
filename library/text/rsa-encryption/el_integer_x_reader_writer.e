note
	description: "[
		Adapter interface to read and write [$source INTEGER_X] from/to instance of [$source EL_MEMORY_READER_WRITER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_INTEGER_X_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [INTEGER_X]

	INTEGER_X_FACILITIES

feature -- Basic operations

	write (item: INTEGER_X; writer: EL_MEMORY_READER_WRITER)
		local
			i, l_count: INTEGER; l_area: SPECIAL [NATURAL_32]
		do
			l_count := item.count; l_area := item.item
			writer.write_integer_32 (l_count)
			from i := 0 until i = l_count loop
				writer.write_natural_32 (l_area [i])
				i := i + 1
			end
		end

	set (item: INTEGER_X; reader: EL_MEMORY_READER_WRITER)
		local
			i, l_count: INTEGER; l_area: SPECIAL [NATURAL_32]
		do
			l_count := reader.read_integer_32
			create l_area.make_empty (l_count)
			from i := 0 until i = l_count loop
				l_area.extend (reader.read_natural_32)
				i := i + 1
			end
			item.item_set (l_area)
			item.count_set (l_count)
		end

end