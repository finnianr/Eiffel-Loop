note
	description: "Summary description for {EL_EIFFEL_SOURCE_MANIFEST_CLASS_RENAMER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:33 GMT (Tuesday 2nd September 2014)"
	revision: "5"

class
	EIFFEL_CLASS_RENAMER_COMMAND

inherit
	EIFFEL_SOURCE_MANIFEST_EDITOR_COMMAND
		rename
			make as make_editor
		redefine
			execute
		end

	EL_MODULE_STRING

	EL_MODULE_USER_INPUT

create
	make, default_create

feature {EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION} -- Initialization

	make (source_manifest_path: EL_FILE_PATH; a_old_class_name, a_new_class_name: STRING)
		do
			old_class_name := a_old_class_name; new_class_name := a_new_class_name
			make_editor (source_manifest_path)
		end

feature -- Basic operations

	execute
		local
			is_done: BOOLEAN
			user_input_file_path: EL_FILE_PATH
			user_input_line: STRING
		do
--			log_or_io.put_path_field ("SOURCE ROOT", tree_path)
			log_or_io.put_new_line
			log_or_io.put_new_line
			if new_class_name.is_empty then
				from  until is_done loop
					user_input_line := User_input.line ("Drag and drop class file")
					user_input_line.right_adjust; user_input_line.left_adjust

					across quote_types as quotes loop
						if String.has_enclosing (user_input_line, quotes.item) then
							String.remove_bookends (user_input_line, quotes.item)
						end
					end
					if user_input_line.as_upper.is_equal ("QUIT") then
						is_done := true
					else
						user_input_file_path := user_input_line
						old_class_name.share (user_input_file_path.without_extension.base.as_upper)

						new_class_name.share (User_input.line ("New class name"))
						new_class_name.left_adjust; new_class_name.right_adjust
						file_editor.set_pattern_changed
						Precursor; change_manifest_class_name
					end
				end
			else
				Precursor; change_manifest_class_name
			end
		end

feature {NONE} -- Implementation

	create_file_editor: EIFFEL_CLASS_RENAMER
		do
			create Result.make (old_class_name, new_class_name)
		end

	change_manifest_class_name
		local
			lower_old_class_name: ASTRING
			found: BOOLEAN
		do
			log.enter ("change_manifest_class_name")
			lower_old_class_name := old_class_name.as_lower
			across manifest.file_list as source_path until found loop
				if source_path.item.base.starts_with (lower_old_class_name)
					and then source_path.item.without_extension.base ~ lower_old_class_name
				then
					source_path.item.base.wipe_out
					source_path.item.base.append (new_class_name.as_lower + ".e")
					log.put_path_field ("Manifest", source_path.item); log.put_new_line
					found := True
				end
			end
			log.exit
		end

	old_class_name: STRING

	new_class_name: STRING

feature {NONE} -- Constants

	Quote_types: ARRAY [READABLE_STRING_GENERAL]
			--
		once
			Result := << "%"%"", "''" >>
		end

end
