note
	description: "Inclusion list file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-16 14:08:09 GMT (Wednesday 16th February 2022)"
	revision: "13"

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
			dir_path, target_parent, specifier_path: DIR_PATH
		do
			target_parent := backup.target_dir.parent
			if is_wild_card (file_specifier) then
				specifier_path := Directory.new (Short_directory_current) #+ file_specifier
				if attached OS.find_files_command (specifier_path.parent, specifier_path.base) as cmd then
					cmd.set_depth (1 |..| 1)
					cmd.set_follow_symbolic_links (True)
					cmd.set_working_directory (target_parent)

					cmd.execute

					across cmd.path_list as found_path loop
						create dir_path
						dir_path.append_path (found_path.item.parent)
						dir_path.append_step (found_path.item.base)
						if dir_path.first_step ~ Short_directory_current then
							dir_path.remove_head (1)
						end
						Precursor (dir_path.to_string)
					end
				end
			else
				Precursor (file_specifier)
			end
		end

	specifier_list: EL_ZSTRING_LIST
			--
		do
			Result := backup.include_list
		end

feature {NONE} -- Constants

	Short_directory_current: ZSTRING
		once
			Result := "."
		end

	File_name: STRING
			--
		once
			Result := "include.txt"
		end

end