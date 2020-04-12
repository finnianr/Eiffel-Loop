note
	description: "Duplicity restore file command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-12 12:13:49 GMT (Sunday 12th April 2020)"
	revision: "3"

class
	DUPLICITY_RESTORE_FILE_OS_CMD

inherit
	DUPLICITY_RESTORE_ALL_OS_CMD
		redefine
			make, Cmd_template
		end

create
	make

feature {NONE} -- Initialization

	make (restore: DUPLICITY_RESTORE; time: DATE_TIME; target_path: EL_FILE_PATH)
		do
			Precursor (restore, time, target_path)
			put_path (Var_target_path, target_path)
		end

feature {NONE} -- Constants

	Var_target_path: STRING = "target_path"

	Cmd_template: STRING
		once
			create Result.make_from_string (Precursor)
			Result.replace_substring_all ("$time", "$time --file-to-restore $target_path")
		end

end
