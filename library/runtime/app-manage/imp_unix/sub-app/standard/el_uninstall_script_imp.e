note
	description: "Unix implementation of ${EL_UNINSTALL_SCRIPT_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 18:03:54 GMT (Tuesday 9th January 2024)"
	revision: "11"

class
	EL_UNINSTALL_SCRIPT_IMP

inherit
	EL_UNINSTALL_SCRIPT_I
		redefine
			serialize
		end

	EL_MODULE_FILE

create
	make

feature -- Basic operations

	serialize
		do
			Precursor
			File.add_permission (output_path, "uog", "x")
		end

feature {NONE} -- Implementation

	script_encoding: EL_ENCODEABLE_AS_TEXT
		do
			create Result.make_default
		end

	uninstall_command_parts: ARRAY [ZSTRING]
		do
			Result := << Application_path.escaped, uninstall_option >>
		end

feature {NONE} -- Constants

	Dot_extension: STRING = "sh"

	Lio_visible_types: ARRAY [TYPE [EL_MODULE_LIO]]
		once
			Result := << {EL_XDG_DESKTOP_DIRECTORY}, {EL_XDG_DESKTOP_LAUNCHER} >>
		end

	Remove_dir_and_parent_commands: ZSTRING
		once
			-- '#' = '%S' substitution marker
			Result := "[
				rm -r #
				find # -maxdepth 0 -empty -exec rmdir {} \;
			]"
		end

	-- In `Template' $RETVAL must be escaped with $$

	Template: STRING = "[
		#!/usr/bin/env bash
		$uninstall_command
		RETVAL=$?
		if [ $$RETVAL -eq 0 ]
		then
			. $remove_files_script_path
			rm $remove_files_script_path
			echo $completion_message
			read -p '<$return_prompt>' str
			rm $script_path
		fi
	]"

end