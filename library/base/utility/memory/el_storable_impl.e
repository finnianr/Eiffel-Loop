note
	description: "Summary description for {EL_STORABLE_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-20 12:12:22 GMT (Monday 20th November 2017)"
	revision: "3"

class
	EL_STORABLE_IMPL

inherit
	EL_STORABLE

create
	make_default

feature {NONE} -- Implementation

	read_version (a_reader: EL_MEMORY_READER_WRITER; version: NATURAL)
			-- Read version compatible with software version
		do
		end

feature {NONE} -- Constants

	Field_hash_checksum: NATURAL = 0

end
