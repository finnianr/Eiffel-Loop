note
	description: "Shared reader writer table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-13 16:56:20 GMT (Saturday 13th February 2021)"
	revision: "1"

deferred class
	EL_SHARED_READER_WRITER_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Reader_writer_table: HASH_TABLE [EL_READER_WRITER_INTERFACE [ANY], INTEGER]
		once
			create Result.make (7)
		end

end