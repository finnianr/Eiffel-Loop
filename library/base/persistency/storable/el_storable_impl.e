note
	description: "Do nothing implemention of ${EL_STORABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "13"

class
	EL_STORABLE_IMPL

inherit
	EL_STORABLE

create
	make_default

feature {NONE} -- Initialization

	make_default
		do
		end

feature -- Element change

	read_default (a_reader: EL_MEMORY_READER_WRITER)
			-- Read default (current) version of data
		do
		end

	read_version (a_reader: EL_MEMORY_READER_WRITER; version: NATURAL)
			-- Read version compatible with software version
		do
		end

feature -- Basic operations

	write (a_writer: EL_MEMORY_READER_WRITER)
		do
		end

feature {NONE} -- Constants

	field_hash: NATURAL = 0

end