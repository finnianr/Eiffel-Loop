note
	description: "Class renaming app for set of classes defined by source manifest"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-02 21:58:30 GMT (Sunday 2nd January 2022)"
	revision: "21"

class
	CLASS_RENAMING_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [CLASS_RENAMING_COMMAND]
		redefine
			Option_name, initialize, set_closed_operands, run
		end

	EL_INSTALLABLE_SUB_APPLICATION
		rename
			desktop_menu_path as Default_desktop_menu_path,
			desktop_launcher as Default_desktop_launcher
		end

	EL_COMMAND_ARGUMENT_CONSTANTS

	EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	initialize
		do
			if not user_quit then
				Precursor
			end
		end

feature -- Basic operations

	run
			--
		do
			if run_once and not user_quit then
				command.execute
			else
				-- run in a loop
				from until user_quit loop
					command.execute
					set_class_names
				end
			end
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("sources", "Path to sources manifest file", << file_must_exist >>),
				optional_argument ("old", "Old class name"),
				optional_argument ("new", "New class name")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "", "")
		end

	new_name: STRING
		do
			if attached {STRING} operands.reference_item (operands.count) as l_name then
				Result := l_name
			else
				create Result.make_empty
			end
		end

	old_name: STRING
		do
			if attached {STRING} operands.reference_item (operands.count - 1) as l_name then
				Result := l_name
			else
				create Result.make_empty
			end
		end

	set_class_names
		local
			input: EL_INPUT_PATH [EL_FILE_PATH]
		do
			lio.put_new_line
			lio.put_new_line
			create input
			input.wipe_out
			input.check_path ("Drag and drop class file")
			if input.path.base.as_upper.is_equal ("QUIT") then
				user_quit := true
			else
				old_name.share (input.path.base_sans_extension.as_upper)

				new_name.share (User_input.line ("New class name"))
				new_name.left_adjust; new_name.right_adjust
				lio.put_new_line
			end
		end

	set_closed_operands
			--
		do
			Precursor
			if old_name.is_empty then
				set_class_names
			else
				run_once := True
			end
		end

feature {NONE} -- Internal attributes

	run_once: BOOLEAN

	user_quit: BOOLEAN

feature {NONE} -- Constants

	Description: STRING = "Rename classes defined by a source manifest file"

	Desktop: EL_DESKTOP_ENVIRONMENT_I
		once
			Result := new_context_menu_desktop ("Eiffel Loop/Development/Rename a class")
		end

	Option_name: STRING = "class_rename"

end