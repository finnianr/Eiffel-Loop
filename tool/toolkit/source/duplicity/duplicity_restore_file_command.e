note
	description: "Duplicity restore file command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-15 11:30:28 GMT (Friday 15th March 2019)"
	revision: "1"

class
	DUPLICITY_RESTORE_FILE_COMMAND

inherit
	DUPLICITY_RESTORE_ALL_COMMAND
		rename
			make as make_restore_all
		redefine
			Cmd_template
		end

create
	make

feature {NONE} -- Initialization

	make (date: STRING; target_path, restored_path: EL_FILE_PATH; backup_uri: EL_DIR_URI_PATH)
		do
			make_restore_all (date, restored_path, backup_uri)
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
