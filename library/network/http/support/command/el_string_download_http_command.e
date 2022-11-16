note
	description: "String download http command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_STRING_DOWNLOAD_HTTP_COMMAND

inherit
	EL_DOWNLOAD_HTTP_COMMAND
		redefine
			make, reset, execute
		end

create
	make

feature {NONE} -- Initialization

	make (a_connection: like connection)
		do
			Precursor (a_connection)
			create string.make_empty
		end

feature -- Access

	string: STRING

feature -- Basic operations

	execute
		do
			Precursor
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