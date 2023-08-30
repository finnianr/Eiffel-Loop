note
	description: "File manifest in Pyxis format"
	notes: "[
		Example manifest
			pyxis-doc:
				version = 1.0; encoding = "UTF-8"
			manifest:
				# Project
				group:
					location = "localization"
					files:
						"*"

				# Eiffel-Loop
				group:
					location = "$EIFFEL/library/Eiffel-Loop/library/localization"
					files:
						"base/*"
						"text-process/*"
						"currency/*"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-28 13:16:47 GMT (Monday 28th August 2023)"
	revision: "1"

class
	EL_PYXIS_FILE_MANIFEST

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, make_from_file, building_action_table
		end

	EL_MODULE_FILE_SYSTEM

	EL_CHARACTER_32_CONSTANTS

create
	make, make_from_file

feature {NONE} -- Initialization

	make (a_file_path: FILE_PATH; extension: READABLE_STRING_GENERAL)
		do
			file_extension := extension
			make_from_file (a_file_path)
		end

	make_from_file (a_file_path: FILE_PATH)
			--
		do
			manifest_path := a_file_path
			Precursor (a_file_path)
		end

	make_default
			--
		do
			create file_list.make_empty
			create bad_path_list.make_empty
			Precursor
		end

feature -- Access

	bad_path_list: EL_ARRAYED_LIST [EL_PATH]

	file_list: EL_FILE_PATH_LIST

feature -- Status query

	has_errors: BOOLEAN
		do
			Result := bad_path_list.count > 0
		end

feature -- Basic operations

	display_bad_paths (log: EL_LOGGABLE)
		do
			across bad_path_list as list loop
				log.put_path_field ("Missing %S", list.item)
				log.put_new_line
			end
		end

feature {NONE} -- Build from Pyxis

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["group/@location",	  agent do location_dir := node.to_expanded_dir_path end],
				["group/files/text()", agent extend_file_list]
			>>)
		end

	extend_file_list
		local
			file_path: EL_FILE_PATH; parent_dir: DIR_PATH
			dir_list: EL_FILE_PATH_LIST
		do
			if location_dir.exists then
				file_path := location_dir + node.adjusted (False)
				if file_path.base ~ char ('*') * 1 then
					parent_dir := file_path.parent
					if parent_dir.exists then
						if attached file_extension as extension then
							dir_list := File_system.files_with_extension (parent_dir, extension, True)
						else
							dir_list := File_system.files (parent_dir, True)
						end
						across dir_list as list loop
							if list.item /~ manifest_path then
								file_list.extend (list.item)
							end
						end
					else
						bad_path_list.extend (parent_dir)
					end

				elseif file_path.exists then
					file_list.extend (file_path)
				else
					bad_path_list.extend (file_path)
				end

			elseif attached bad_path_list as list then
				if list.count = 0 or else list.last /= location_dir then
					list.extend (location_dir)
				end
			end
		end

feature {NONE} -- Internal attributes

	location_dir: DIR_PATH

	file_extension: detachable READABLE_STRING_GENERAL

	manifest_path: FILE_PATH

feature {NONE} -- Constants

	Root_node_name: STRING = "manifest"

end