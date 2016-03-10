note
	description: "Summary description for {INCLUSION_LIST_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:33 GMT (Tuesday 2nd September 2014)"
	revision: "4"

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

	put_file_specifier (specifier_name, file_specifier: ASTRING)
			--
		local
			find_files_command: EL_FIND_FILES_COMMAND
			path_steps: EL_PATH_STEPS
			target_parent, specifier_path: EL_DIR_PATH
		do
			target_parent := target_path.parent
			if specifier_name ~ Specifier_file then
				Precursor (specifier_name, file_specifier)

			elseif specifier_name ~ Specifier_all_files then
				specifier_path := Directory.path (Short_directory_current).joined_dir_path (file_specifier)
				create find_files_command.make (specifier_path.parent, specifier_path.base)
				find_files_command.disable_recursion
				find_files_command.set_follow_symbolic_links (True)
				find_files_command.set_working_directory (target_parent)
				log_or_io.put_path_field ("Working", find_files_command.working_directory)
				log_or_io.put_new_line
				find_files_command.execute

				across find_files_command.path_list as found_path loop
					create path_steps
					path_steps.append (found_path.item.parent.steps)
					path_steps.extend (found_path.item.base)
					if path_steps.first ~ Short_directory_current then
						path_steps.start; path_steps.remove
					end

					Precursor (Specifier_file, path_steps.as_directory_path.to_string)
				end
			end
		end

feature {NONE} -- Constants

	Specifier_all_files: ASTRING
		once
			Result := "all-files"
		end

	Specifier_file: ASTRING
		once
			Result := "file"
		end

	Short_directory_current: ASTRING
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
