note
	description: "A command line interface to the class [$source DUPLICITY_RESTORE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-28 10:49:02 GMT (Thursday 28th February 2019)"
	revision: "4"

class
	DUPLICITY_RESTORE_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [DUPLICITY_RESTORE]
		redefine
			Option_name, initialize
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("in", "Input file path", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make (create {EL_FILE_PATH})
		end

	initialize
		do
			Console.show ({EL_CAPTURED_OS_COMMAND})
			Precursor
		end

feature {NONE} -- Constants

	Description: STRING = "Restore files from a duplicity backup"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines]
			>>
		end

	Option_name: STRING = "duplicity_restore"

end
