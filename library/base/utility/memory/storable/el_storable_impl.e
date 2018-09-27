note
	description: "Storable impl"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "8"

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
