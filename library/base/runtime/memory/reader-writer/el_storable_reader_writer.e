note
	description: "[
		Adapter interface to read a [$source EL_STORABLE] item from [$source EL_READABLE]
		and write an item to [$source EL_WRITABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-16 18:10:21 GMT (Friday 16th December 2022)"
	revision: "6"

class
	EL_STORABLE_READER_WRITER [S -> EL_STORABLE create make_default end]

inherit
	EL_READER_WRITER_INTERFACE [S]

feature -- Basic operations

	read_item (reader: EL_READABLE): S
		do
			create Result.make_default
			set (Result, reader)
		end

	set (item: like read_item; reader: EL_READABLE)
		do
			if attached {EL_MEMORY_READER_WRITER} reader as memory then
				item.read (memory)
			end
		end

	write (item: like read_item; writer: EL_WRITABLE)
		do
			if attached {EL_MEMORY_READER_WRITER} writer as memory then
				item.write (memory)
			end
		end

end