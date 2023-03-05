note
	description: "Class renaming command for set of classes defined by source manifest"
	notes: "[
		When renaming an interface class ending with "_I", the corresponding implementation class ending
		with "_IMP" will be also renamed accordingly.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-05 17:39:10 GMT (Sunday 5th March 2023)"
	revision: "31"

class
	CLASS_RENAMING_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		rename
			make as make_command
		redefine
			execute, make_default
		end

	EL_MODULE_FILE_SYSTEM; EL_MODULE_FILE

create
	make

feature {EL_APPLICATION} -- Initialization

	make (a_manifest: SOURCE_MANIFEST; a_old_name, a_new_name: STRING)
		require
			old_name_not_empty: not a_old_name.is_empty
			new_name_not_empty: not a_new_name.is_empty
		do
			old_name := a_old_name; new_name := a_new_name
			make_from_manifest (a_manifest)
		end

	make_default
		do
			Precursor
			create renamer.make
		end

feature -- Constants

	Description: STRING = "Rename classes defined by a source manifest file"

feature -- Basic operations

	execute
		local
			old_imp_base_name: ZSTRING
		do
			log_rename; Precursor
			-- Check for _IMP file if class ends with "_I"
			if old_name.ends_with ("_I") and new_name.ends_with ("_I") then
				old_imp_base_name := old_name.as_lower + "mp.e"
				if across manifest.file_list as list some list.item.same_base (old_imp_base_name) end then
					new_name.append_string_general ("MP")
					old_name.append_string_general ("MP")
				end
				lio.put_new_line
				log_rename; Precursor
			end
		end

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		do
			renamer.set_source_text (File.plain_text (source_path), old_name)
			if renamer.whole_identifier_count > 0 then
				-- Check if `source_path' is class definition file
				if source_path.base_matches (old_name, True) then
					File_system.remove_path (source_path)
					source_path.set_base_name (new_name.as_lower)
				end
				File.write_text (source_path, renamer.replaced_source (new_name))
			end
		end

	log_rename
		do
			lio.put_labeled_substitution ("Renaming class", "%S as %S", [old_name, new_name])
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	new_name: STRING

	old_name: STRING

	renamer: CLASS_RENAMER

end