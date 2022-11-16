note
	description: "Duplicity OS command with `target_uri'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	DUPLICITY_OS_COMMAND

inherit
	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Implementation

	set_target_dir (a_target_dir: EL_DIR_URI_PATH)
		do
			template.set_variable (Var_target_dir, File_system.escaped_path (a_target_dir.to_string))
		end

	template: EL_ZSTRING_TEMPLATE
		deferred
		end

feature {NONE} -- Constants

	Var_target_dir: STRING = "target_dir"

invariant
	valid_template: template.has_variable (Var_target_dir)
end