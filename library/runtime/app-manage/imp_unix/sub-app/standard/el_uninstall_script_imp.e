note
	description: "Unix implementation of [$source EL_UNINSTALL_SCRIPT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-10 9:03:43 GMT (Monday 10th July 2023)"
	revision: "10"

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