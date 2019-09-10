note
	description: "Inclusion list file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-09 16:42:33 GMT (Monday 9th September 2019)"
	revision: "6"

class
	INCLUSION_LIST_FILE

inherit
	TAR_LIST_FILE
		redefine
			put_file_specifier
		end

	EL_MODULE_COMMAND

	EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Implementation

	put_file_specifier (file_specifier: ZSTRING)
			--
		local
			find_files_cmd: like Command.new_find_files
			path_steps: EL_PATH_STEPS
			target_parent, specifier_path: EL_DIR_PATH
		do
			target_parent := backup.target_dir.parent
			if is_wild_card (file_specifier) then
				specifier_path := Directory.new_path (Short_directory_current).joined_dir_path (file_specifier)
				find_files_cmd := Command.new_find_files (specifier_path.parent, specifier_path.base)
				find_files_cmd.set_depth (1 |..| 1)
				find_files_cmd.set_follow_symbolic_links (True)
				find_files_cmd.set_working_directory (target_parent)
				lio.put_path_field ("Working", find_files_cmd.working_directory)
				lio.put_new_line
				find_files_cmd.execute

				across find_files_cmd.path_list as found_path loop
					create path_steps
					path_steps.append (found_path.item.parent.steps)
					path_steps.extend (found_path.item.base)
					if path_steps.first ~ Short_directory_current then
						path_steps.remove_head (1)
					end
					Precursor (path_steps.as_directory_path.to_string)
				end
			else
				Precursor (file_specifier)
			end
		end

feature {NONE} -- Constants

	Short_directory_current: ZSTRING
		once
			Result := "."
		end

	specifier_list: EL_ZSTRING_LIST
			--
		once
			Result := backup.include_list
		end

	File_name: STRING
			--
		once
			Result := "include.txt"
		end

end
