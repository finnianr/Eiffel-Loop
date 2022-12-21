note
	description: "[
		Adapter interface to read a string conforming to [$source READABLE_STRING_GENERAL] item
		from [$source EL_READABLE] and write an item to [$source EL_WRITABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-21 17:47:19 GMT (Wednesday 21st December 2022)"
	revision: "6"

deferred class
	EL_STRING_GENERAL_READER_WRITER [S -> READABLE_STRING_GENERAL create make_empty end]

inherit
	EL_READER_WRITER_INTERFACE [S]

feature -- Factory

	new_item: S
		do
			create Result.make_empty
		end

end