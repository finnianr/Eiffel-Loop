note
	description: "Duplicity restore file command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-12 16:12:11 GMT (Wednesday 12th February 2020)"
	revision: "2"

class
	DUPLICITY_RESTORE_FILE_COMMAND

inherit
	DUPLICITY_RESTORE_ALL_COMMAND
		redefine
			make, Cmd_template
		end

create
	make

feature {NONE} -- Initialization

	make (restore: DUPLICITY_RESTORE; date: DATE; target_path: EL_FILE_PATH)
		do
			Precursor (restore, date, target_path)
			put_path (Var_target_path, target_path)
		end

feature {NONE} -- Constants

	Var_target_path: STRING = "target_path"

	Cmd_template: STRING
		once
			create Result.make_from_string (Precursor)
			Result.replace_substring_all ("$date", "$date --file-to-restore $target_path")
		end

end
