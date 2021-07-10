note
	description: "Inclusion list file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-10 8:34:13 GMT (Saturday 10th July 2021)"
	revision: "8"

class
	INCLUSION_LIST_FILE

inherit
	TAR_LIST_FILE
		redefine
			put_file_specifier
		end

	EL_MODULE_OS

	EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Implementation

	put_file_specifier (file_specifier: ZSTRING)
			--
		local
			path_steps: EL_PATH_STEPS
			target_parent, specifier_path: EL_DIR_PATH
		do
			target_parent := backup.target_dir.parent
			if is_wild_card (file_specifier) then
				specifier_path := Directory.new (Short_directory_current).joined_dir_path (file_specifier)
				if attached OS.find_files_command (specifier_path.parent, specifier_path.base) as cmd then
					cmd.set_depth (1 |..| 1)
					cmd.set_follow_symbolic_links (True)
					cmd.set_working_directory (target_parent)

					lio.put_path_field ("Working", cmd.working_directory)
					lio.put_new_line
					cmd.execute

					across cmd.path_list as found_path loop
						create path_steps
						path_steps.append (found_path.item.parent.steps)
						path_steps.extend (found_path.item.base)
						if path_steps.first ~ Short_directory_current then
							path_steps.remove_head (1)
						end
						Precursor (path_steps.as_directory_path.to_string)
					end
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