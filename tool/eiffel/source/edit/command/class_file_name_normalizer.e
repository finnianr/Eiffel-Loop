note
	description: "Class file name normalizer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-12 10:09:28 GMT (Tuesday 12th March 2024)"
	revision: "11"

class
	CLASS_FILE_NAME_NORMALIZER

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			execute, make_default
		end

	EL_EIFFEL_SOURCE_LINE_STATE_MACHINE
		rename
			make as make_machine,
			class_name as class_name_pattern
		export
			{NONE} all
		end

	EL_MODULE_FILE_SYSTEM

	EL_EIFFEL_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			make_machine
			create class_name.make_empty
			create renamed_table.make_equal (20)
		end

feature -- Access

	Description: STRING = "Normalize class filenames as lowercase classnames within a source directory"

	renamed_table: EL_ZSTRING_HASH_TABLE [ZSTRING]

feature -- Basic operations

	execute
		do
			renamed_table.wipe_out
			Precursor
			if renamed_table.count > 0 then
				lio.put_line ("RENAMED")
				across renamed_table as table loop
					lio.put_labeled_string (table.key, "as " + table.item)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- State handlers

	find_class_declaration (line: ZSTRING)
		do
			if code_line_is_class_declaration then
				class_name := code_line_class_name
				if class_name.is_empty then
					state := agent find_class_name
				else
					state := final
				end
			end
		end

	find_class_name (line: ZSTRING)
		do
			class_name := code_line_class_name
			if class_name.count > 0 then
				state := final
			end
		end

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		local
			new_path: FILE_PATH
		do
			do_once_with_file_lines (agent find_class_declaration, open_lines (source_path, Latin_1))
			if attached class_name.as_lower as name_lower and then source_path.base_name /~ name_lower then
				new_path := source_path.parent + name_lower
				new_path.add_extension (E_extension)
				File_system.rename_file (source_path, new_path)
				renamed_table [source_path.base] := new_path.base
			end
		end

feature {NONE} -- Internal attributes

	class_name: ZSTRING

end