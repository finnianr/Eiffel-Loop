note
	description: "OS command to mirror a directory either locally or remotely"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 8:49:06 GMT (Tuesday 9th July 2024)"
	revision: "5"

deferred class
	EL_MIRROR_COMMAND [VARIABLES -> TUPLE create default_create end]

inherit
	EL_PARSED_OS_COMMAND [VARIABLES]
		rename
			make as make_parsed
		undefine
			default_template
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