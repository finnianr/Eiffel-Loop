note
	description: "A command line interface to the class [$source DUPLICITY_BACKUP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-29 13:37:49 GMT (Tuesday 29th January 2019)"
	revision: "1"

class
	DUPLICITY_BACKUP_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [DUPLICITY_BACKUP]
		redefine
			Option_name, initialize
		end

create
	make

feature {NONE} -- Implementation

	initialize
		do
			Console.show ({EL_CAPTURED_OS_COMMAND})
			Precursor
		end

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

feature {NONE} -- Constants

	Option_name: STRING = "duplicity"

	Description: STRING = "Create an incremental backup with duplicity command"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines]
			>>
		end

end
