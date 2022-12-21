note
	description: "[
		Adapter interface to read a [$source EL_MAKEABLE] item from [$source EL_READABLE]
		and write an item to [$source EL_WRITABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-21 17:18:59 GMT (Wednesday 21st December 2022)"
	revision: "8"

class
	EL_MAKEABLE_READER_WRITER [M -> EL_MAKEABLE create make end]

inherit
	EL_READER_WRITER_INTERFACE [M]

feature -- Factory

	new_item: M
		do
			create Result.make
		end

feature -- Basic operations

	read_item (reader: EL_READABLE): like new_item
		do
			Result := new_item
			set (Result, reader)
		end

	set (item: like new_item; reader: EL_READABLE)
		do
			if attached {EL_MEMORY_READER_WRITER} reader as memory
				and then attached {EL_STORABLE} item as storable
			then
				storable.read (memory)
			end
		end

	write (item: like new_item; writer: EL_WRITABLE)
		do
			if attached {EL_MEMORY_READER_WRITER} writer as memory
				and then attached {EL_STORABLE} item as storable
			then
				storable.write (memory)
			end
		end

end