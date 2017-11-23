note
	description: "Summary description for {EL_STORABLE_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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
