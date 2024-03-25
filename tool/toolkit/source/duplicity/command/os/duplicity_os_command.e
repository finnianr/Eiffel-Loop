note
	description: "Duplicity OS command with `target_uri'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-25 16:47:18 GMT (Monday 25th March 2024)"
	revision: "4"

deferred class
	DUPLICITY_OS_COMMAND

inherit
	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Implementation

	set_target_dir (a_target_dir: EL_DIR_URI_PATH)
		do
			template.put (Var_target_dir, File_system.escaped_path (a_target_dir.to_string))
		end

	template: EL_TEMPLATE [ZSTRING]
		deferred
		end

feature {NONE} -- Constants

	Var_target_dir: STRING = "target_dir"

invariant
	valid_template: template.has (Var_target_dir)
end