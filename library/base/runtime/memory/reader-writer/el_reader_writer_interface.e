note
	description: "[
		Adapter interface to read and write `item: G' from/to instance of [$source EL_MEMORY_READER_WRITER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-14 10:47:12 GMT (Sunday 14th February 2021)"
	revision: "2"

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