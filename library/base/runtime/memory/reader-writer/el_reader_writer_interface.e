note
	description: "[
		Adapter interface to read and write `item: G' from/to instance of [$source EL_MEMORY_READER_WRITER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	EL_READER_WRITER_INTERFACE [G]

feature -- Basic operations

	write (item: G; writer: EL_MEMORY_READER_WRITER)
		deferred
		end

	set (item: G; reader: EL_MEMORY_READER_WRITER)
		deferred
		end

end