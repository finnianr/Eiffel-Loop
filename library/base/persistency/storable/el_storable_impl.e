note
	description: "Storable impl"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	EL_STORABLE_IMPL

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			foreign_naming as eiffel_naming
		end

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