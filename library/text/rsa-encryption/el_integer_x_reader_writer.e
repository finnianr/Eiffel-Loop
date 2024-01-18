note
	description: "[
		Adapter interface to read a ${INTEGER_X} item from ${EL_READABLE}
		and write an item to ${EL_WRITABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-21 17:45:50 GMT (Wednesday 21st December 2022)"
	revision: "8"

class
	EL_INTEGER_X_READER_WRITER

inherit
	EL_READER_WRITER_INTERFACE [INTEGER_X]

	INTEGER_X_FACILITIES

feature -- Factory

	new_item: INTEGER_X
		do
			create Result
		end

feature -- Basic operations

	read_item (reader: EL_READABLE): INTEGER_X
		do
			create Result
			set (Result, reader)
		end

	set (item: INTEGER_X; reader: EL_READABLE)
		do
			if attached read_array (reader) as array then
				item.item_set (array)
				item.count_set (array.count)
			end
		end

	write (item: INTEGER_X; writer: EL_WRITABLE)
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

feature {NONE} -- Implementation

	read_array (reader: EL_READABLE): SPECIAL [NATURAL_32]
		local
			i, l_count: INTEGER
		do
			l_count := reader.read_integer_32
			create Result.make_empty (l_count)
			from i := 0 until i = l_count loop
				Result.extend (reader.read_natural_32)
				i := i + 1
			end
		end

end