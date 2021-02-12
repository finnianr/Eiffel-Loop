note
	description: "An `INTEGER_X' conforming to [$source EL_STORABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-12 13:09:20 GMT (Friday 12th February 2021)"
	revision: "1"

class
	EL_STORABLE_INTEGER_X

inherit
	EL_STORABLE
		rename
			make_default as make,
			read_version as read_default_version
		undefine
			copy, default_create, is_equal, out
		redefine
			is_equal
		end

	INTEGER_X_FACILITIES
		export
			{NONE} all
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create item
		end

feature -- Access

	item: INTEGER_X

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := item ~ other.item
		end

feature -- Element change

	set_item (a_item: INTEGER_X)
		do
			item := a_item
		end

feature -- Basic operations

	write (a_writer: EL_MEMORY_READER_WRITER)
		local
			i, l_count: INTEGER; l_area: like item.item
		do
			l_count := item.count; l_area := item.item
			a_writer.write_integer_32 (l_count)
			from i := 0 until i = l_count loop
				a_writer.write_natural_32 (l_area [i])
				i := i + 1
			end
		end

feature -- Element change

	read_default (a_reader: EL_MEMORY_READER_WRITER)
			-- Read default (current) version of data
		local
			l_count, i: INTEGER; l_area: like item.item
		do
			l_count := a_reader.read_integer_32
			create item.make_limbs (l_count)
			item.count_set (l_count)
			l_area := item.item
			from i := 0 until i = l_count loop
				l_area.put (a_reader.read_natural_32, i)
				i := i + 1
			end
		end

end