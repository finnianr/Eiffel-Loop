note
	description: "A storable arrayed list of types conforming to ${TUPLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 10:35:20 GMT (Thursday 11th July 2024)"
	revision: "1"

class
	ECD_ARRAYED_TUPLE_LIST [G -> TUPLE create default_create end]

inherit
	ECD_CHAIN [G]
		rename
			on_delete as do_nothing,
			make_chain_implementation as make_sized
		end

	EL_ARRAYED_LIST [G]
		rename
			make as make_sized
		end

	EL_MODULE_BUILD_INFO

create
	make, make_default, make_from_file

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Allocate list with `n' items.
			-- (`n' may be zero for empty list.)
		do
			make_default
			make_sized (n)
		end

feature -- Access

	software_version: NATURAL
		do
			Result := Build_info.version_number
		end

feature {NONE} -- Implementation

	new_reader_writer: ECD_TUPLE_READER_WRITER [G]
		do
			create Result.make
		end

	new_stored_item (reader: like new_reader_writer; file: RAW_FILE): like item
		do
			Result := reader.read_item (file)
		end

	write_item (writer: like new_reader_writer; file: RAW_FILE)
		do
			writer.write (item, file)
			progress_listener.notify_tick
		end

end