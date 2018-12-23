note
	description: "Class renamer command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-05 9:00:58 GMT (Tuesday 5th June 2018)"
	revision: "9"

class
	CLASS_RENAMER_COMMAND

inherit
	SOURCE_MANIFEST_EDITOR_COMMAND
		rename
			make as make_editor
		redefine
			execute
		end

	EL_MODULE_USER_INPUT

create
	make

feature {EL_SUB_APPLICATION} -- Initialization

	make (source_manifest_path: EL_FILE_PATH; a_old_class_name, a_new_class_name: STRING)
		do
			old_class_name := a_old_class_name; new_class_name := a_new_class_name
			make_editor (source_manifest_path)
		end

feature -- Basic operations

	execute
		local
			is_done: BOOLEAN; input: EL_INPUT_PATH [EL_FILE_PATH]
		do
--			log_or_io.put_path_field ("SOURCE ROOT", tree_path)
			lio.put_new_line
			lio.put_new_line
			create input
			if new_class_name.is_empty then
				from  until is_done loop
					input.wipe_out
					input.check_path ("Drag and drop class file")
					if input.path.base.as_upper.is_equal ("QUIT") then
						is_done := true
					else
						old_class_name.share (input.path.base_sans_extension.as_upper)

						new_class_name.share (User_input.line ("New class name"))
						new_class_name.left_adjust; new_class_name.right_adjust
						editor.set_pattern_changed
						Precursor
						lio.put_new_line
					end
				end
			else
				Precursor
			end
		end

feature {NONE} -- Implementation

	new_editor: CLASS_RENAMER
		do
			create Result.make (old_class_name, new_class_name)
		end

	old_class_name: ZSTRING

	new_class_name: ZSTRING

end
