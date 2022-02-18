note
	description: "Inclusion list file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-17 23:20:11 GMT (Thursday 17th February 2022)"
	revision: "12"

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
			target_parent, specifier_path: DIR_PATH
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
						path_steps := found_path.item
						path_steps.remove_tail (1)
						path_steps.extend (found_path.item.base)
						if path_steps.first ~ Short_directory_current then
							path_steps.remove_head (1)
						end
						Precursor (path_steps)
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