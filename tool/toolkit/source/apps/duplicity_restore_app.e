note
	description: "A command line interface to the class [$source DUPLICITY_RESTORE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-02 9:28:43 GMT (Monday 2nd September 2019)"
	revision: "8"

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

	visible_types: ARRAY [TYPE [EL_MODULE_LIO]]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			Result := << {EL_CAPTURED_OS_COMMAND}, {DUPLICITY_RESTORE_ALL_COMMAND} >>
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
