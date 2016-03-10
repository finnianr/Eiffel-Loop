note
	description: "Summary description for {EL_COPY_FILE_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	EL_COPY_FILE_COMMAND

inherit
	EL_DOUBLE_OPERAND_FILE_SYSTEM_COMMAND [EL_COPY_FILE_IMPL]
		redefine
			make
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (a_source_path, a_destination_path: like source_path)
			--
		do
			Precursor (a_source_path, a_destination_path)
			is_timestamp_preserved := true
		end

feature -- Status query

	is_timestamp_preserved: BOOLEAN

feature -- Element change

	set_timestamp_preserved (flag: BOOLEAN)
			--
		do
			is_timestamp_preserved := flag
		end

end
