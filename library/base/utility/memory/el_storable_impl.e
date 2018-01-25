note
	description: "Summary description for {EL_STORABLE_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-20 10:01:07 GMT (Saturday 20th January 2018)"
	revision: "5"

class
	EL_STORABLE_IMPL

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE

create
	make_default

feature {NONE} -- Implementation

	read_version (a_reader: EL_MEMORY_READER_WRITER; version: NATURAL)
			-- Read version compatible with software version
		do
		end

feature {NONE} -- Constants

	field_hash: NATURAL = 0

end
