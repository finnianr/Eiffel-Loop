note
	description: "Unix implementation of [$source EL_UNINSTALL_SCRIPT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 8:13:49 GMT (Monday 7th February 2022)"
	revision: "8"

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

	uninstall_base_list: EL_ZSTRING_LIST
		do
			create Result.make_from_array (<< escaped (application_path) >>)
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