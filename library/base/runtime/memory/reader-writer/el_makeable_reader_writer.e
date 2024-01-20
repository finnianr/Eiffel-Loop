note
	description: "[
		Adapter interface to read a ${EL_MAKEABLE} item from ${EL_READABLE}
		and write an item to ${EL_WRITABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "9"

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