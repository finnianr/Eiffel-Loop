note
	description: "[
		Adapter interface to read a string conforming to ${READABLE_STRING_GENERAL} item
		from ${EL_READABLE} and write an item to ${EL_WRITABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "8"

deferred class
	EL_STRING_GENERAL_READER_WRITER [S -> READABLE_STRING_GENERAL create make_empty end]

inherit
	EL_READER_WRITER_INTERFACE [S]

	EL_STRING_BIT_COUNTABLE [S]

feature -- Factory

	new_item: S
		do
			create Result.make_empty
		end

end