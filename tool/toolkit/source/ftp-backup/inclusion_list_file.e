note
	description: "Inclusion list file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-25 19:08:36 GMT (Tuesday 25th December 2018)"
	revision: "5"

class
	INCLUSION_LIST_FILE

inherit
	EXCLUSION_LIST_FILE
		redefine
			Query_path, File_name,  Info_heading, put_file_specifier
		end
create
	make

feature {NONE} -- Implementation

	put_file_specifier (specifier_name, file_specifier: ZSTRING)
			--
		local
			find_files_cmd: like Command.new_find_files
			path_steps: EL_PATH_STEPS
			target_parent, specifier_path: EL_DIR_PATH
		do
			target_parent := target_path.parent
			if specifier_name ~ Specifier_file then
				Precursor (specifier_name, file_specifier)

			elseif specifier_name ~ Specifier_all_files then
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
					Precursor (Specifier_file, path_steps.as_directory_path.to_string)
				end
			end
		end

feature {NONE} -- Constants

	Specifier_all_files: ZSTRING
		once
			Result := "all-files"
		end

	Specifier_file: ZSTRING
		once
			Result := "file"
		end

	Short_directory_current: ZSTRING
		once
			Result := "."
		end

	Query_path: STRING_32
			--
		once
			Result := "include/child::*"
		end

	File_name: STRING
			--
		once
			Result := "include.txt"
		end

	Info_heading: STRING
			--
		once
			Result := "INCLUDE FILES:"
		end

end
