note
	description: "[
		Adapter interface to read item of type **G** from [$source EL_READABLE]
		and write an item to [$source EL_WRITEABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-08 19:12:23 GMT (Thursday 8th December 2022)"
	revision: "4"

deferred class
	EL_READER_WRITER_INTERFACE [G]

feature -- Access

	item_type: TYPE [G]
		do
			Result := {G}
		end

feature -- Basic operations

	read_item (reader: EL_READABLE): G
		deferred
		end

	set (item: G; reader: EL_READABLE)
		deferred
		end

	write (item: G; writer: EL_WRITEABLE)
		deferred
		end

end