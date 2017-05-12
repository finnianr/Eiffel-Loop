note
	description: "Summary description for {EL_HTTP_STRING_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-11 11:58:46 GMT (Thursday 11th May 2017)"
	revision: "1"

class
	EL_HTTP_STRING_COMMAND

inherit
	EL_HTTP_DOWNLOAD_COMMAND
		redefine
			make, reset, execute
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create string.make_empty
		end

feature -- Access

	string: STRING

feature -- Basic operations

	execute (connection: EL_HTTP_CONNECTION)
		do
			Precursor (connection)
			string.right_adjust
			if string.has ('%R') then
				string.replace_substring_all (once "%R%N", once "%N")
			end
		end

feature {NONE} -- Implementation

	on_string_transfer (a_string: STRING)
		do
			string.append (a_string)
		end

	reset
		do
			string.wipe_out
		end

end
