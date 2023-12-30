note
	description: "[
		Manage list of executable or package file paths with version number between hyphen and dot extension
		
		Eg. `el_eiffel-1.4.1.exe'. Accepts user input by command line.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-30 18:07:14 GMT (Saturday 30th December 2023)"
	revision: "1"

class
	EL_VERSION_PATH_LIST

inherit
	EL_FILE_PATH_LIST
		rename
			make as make_sized,
			occurrences as path_occurrences
		redefine
			make_empty
		end

	EL_MODULE_COMMAND; EL_MODULE_LIO; EL_MODULE_OS; EL_MODULE_USER_INPUT

create
	make, make_empty

feature {NONE} -- Initialization

	make (a_dir_path: DIR_PATH; a_file_pattern: READABLE_STRING_GENERAL)
		do
			make_from_list (OS.file_list (a_dir_path, a_file_pattern))
			dir_path := a_dir_path
		end

	make_empty
		do
			Precursor
			create dir_path
		end

feature -- Access

	sorted_version_list: EL_ARRAYED_LIST [EL_SOFTWARE_VERSION]
		do
			Result := version_set.to_list
			Result.sort (True)
		end

	path_version: EL_SOFTWARE_VERSION
		local
			version, name: ZSTRING
		do
			Result := Default_version
			if path.has_dot_extension then
				if path.extension.is_natural then
					name := path.base -- el_eiffel-1.2.3
				else
					name := path.base_name -- el_eiffel-1.2.3.exe
				end
				version := name.substring_to_reversed ('-', default_pointer)
				if version.occurrences ('.') = 2 then
					Result := version.to_latin_1
				end
			end
		end

	version_set: EL_HASH_SET [EL_SOFTWARE_VERSION]
		do
			push_cursor
			create Result.make (count)
			from start until after loop
				if attached path_version as version and then version /= Default_version then
					Result.put (version)
				end
				forth
			end
			pop_cursor
		end

feature -- Basic operations

	delete_range (name: READABLE_STRING_GENERAL)
		-- delete user specified range of versions by menu number
		local
			input_count: INTEGER; range: INTEGER_INTERVAL; name_parts: EL_STRING_8_LIST
			input: EL_USER_INPUT_VALUE [INTEGER]; version_path, executable_path: FILE_PATH
			version: EL_SOFTWARE_VERSION; version_path_list: EL_FILE_PATH_LIST
			template: STRING
		do
			create version_path_list.make (10)

			display_versions (name)

			if attached sorted_version_list as version_list then
				range := 0 |..| version_list.count
				create input.make_valid ("Enter number to delete from earliest", "Invalid number", agent range.has)
				input_count := input.value
				across version_list as list until list.cursor_index > input_count loop
					version := list.item
					version_path_list.wipe_out
					from start until after loop
						if path_version ~ version then
							lio.put_line (path.base)
							version_path_list.extend (path)
						end
						forth
					end
					template := "%S version %S files"
					if version_path_list.count = 1 then
						template.remove_tail (1)
					end
					lio.put_labeled_substitution ("Delete", template, [version_path_list.count, version.string])
					if User_input.approved_action_y_n ("") then
						across version_path_list as l_path loop
							if attached command.new_delete_file (l_path.item) as cmd then
								cmd.sudo.enable
								cmd.execute
							end
						end
						lio.put_line ("Deleted")
					else
						lio.put_line ("Skipped")
					end
				end
				lio.put_new_line
			end
		end

	display_versions (name: READABLE_STRING_GENERAL)
		-- display menu of available versions
		do
			lio.put_new_line
			lio.put_path_field (Versions_of #$ [name], dir_path)
			lio.put_new_line

			if count > 0 then
				across sorted_version_list as version loop
					lio.put_index_labeled_string (version, Void, version.item.string)
					lio.put_new_line
				end
			else
				lio.put_line ("No versions found")
			end
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	dir_path: DIR_PATH

feature {NONE} -- Constants

	Default_version: EL_SOFTWARE_VERSION
		once
			create Result
		end

	Versions_of: ZSTRING
		once
			Result := "VERSIONS of %S in"
		end

end