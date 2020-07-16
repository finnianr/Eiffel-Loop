note
	description: "A command line interface to the class [$source DUPLICITY_RESTORE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-16 11:16:25 GMT (Thursday 16th July 2020)"
	revision: "12"

class
	DUPLICITY_RESTORE_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [DUPLICITY_RESTORE]
		redefine
			Option_name, visible_types
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("in", "Input file path", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {EL_FILE_PATH})
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines]
			>>
		end

	visible_types: TUPLE [DUPLICITY_COLLECTION_STATUS_OS_CMD]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

feature {NONE} -- Constants

	Description: STRING = "Restore files from a duplicity backup"

	Option_name: STRING = "duplicity_restore"

end
