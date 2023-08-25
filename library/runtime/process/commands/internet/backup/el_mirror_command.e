note
	description: "OS command to mirror a directory either locally or remotely"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-25 17:42:44 GMT (Friday 25th August 2023)"
	revision: "4"

deferred class
	EL_MIRROR_COMMAND [VARIABLES -> TUPLE create default_create end]

inherit
	EL_PARSED_OS_COMMAND [VARIABLES]
		rename
			make as make_parsed
		end

feature {NONE} -- Initialization

	make (config: EL_MIRROR_BACKUP)
		do
			make_parsed
			set_target_dir (config.backup_dir)
		end

feature -- Element change

	set_source_dir (source_dir: DIR_PATH)
		do
			put_path_variable (source_dir_index, source_dir)
		end

	set_target_dir (target_dir: DIR_PATH)
		do
			put_path_variable (target_dir_index, target_dir)
		end

feature {NONE} -- Deferred

	source_dir_index: INTEGER
		do
			Result := target_dir_index - 1
		end

	target_dir_index: INTEGER
		do
			Result := Var.count
		end

end