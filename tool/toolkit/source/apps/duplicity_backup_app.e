note
	description: "A command line interface to the class [$source DUPLICITY_BACKUP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-19 14:42:02 GMT (Tuesday 19th March 2019)"
	revision: "4"

class
	DUPLICITY_BACKUP_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [DUPLICITY_BACKUP]
		redefine
			Option_name, Visible_types
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

feature {NONE} -- Constants

	Description: STRING = "Create an incremental backup with duplicity command"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines]
			>>
		end

	Option_name: STRING = "duplicity"

	Visible_types: ARRAY [TYPE [EL_MODULE_LIO]]
		once
			Result := << {EL_CAPTURED_OS_COMMAND}, {DUPLICITY_TARGET_INFO} >>
		end

end
