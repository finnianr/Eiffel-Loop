note
	description: "Summary description for {EL_STORABLE_IMPL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

feature {NONE} -- Implementation

	read_version (a_reader: EL_MEMORY_READER_WRITER; version: NATURAL)
			-- Read version compatible with software version
		do
		end

end
