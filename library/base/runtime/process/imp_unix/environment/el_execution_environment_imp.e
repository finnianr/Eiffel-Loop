note
	description: "Unix implementation of [$source EL_EXECUTION_ENVIRONMENT_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-11 14:46:57 GMT (Thursday 11th January 2024)"
	revision: "15"

class
	EL_EXECUTION_ENVIRONMENT_IMP

inherit
	EL_EXECUTION_ENVIRONMENT_I
		export
			{NONE} all
		end

	EL_UNIX_IMPLEMENTATION

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Implementation

	console_code_page: NATURAL
			-- For windows. Returns 0 in Unix
		do
		end

	new_language_code: STRING
			-- By example: if LANG = "en_UK.utf-8"
			-- then result = "en"
		do
			if attached item ("LANG") as lang then
				Result := lang.substring_to ('_')
			else
				create Result.make_empty
			end
		end

	open_url (url: EL_FILE_URI_PATH)
		do
			system (Open_url_command + url.escaped)
		end

	set_console_code_page (code_page_id: NATURAL)
			-- For windows commands. Does nothing in Unix
		do
		end

	set_library_path
		-- if directory `build/$ISE_PLATFORM/package/bin' contains shared objects then
		-- add to `LD_LIBRARY_PATH' for Unix platform
		local
			bin_dir: DIR_PATH
		do
			if attached item ("ISE_PLATFORM") as ise_platform then
				bin_dir := Directory.current_working.joined_dir_tuple (["build", ise_platform, "package/bin"])
				if bin_dir.exists and then File_system.files_with_extension (bin_dir, "so", False).count > 0 then
					if attached item (Var_library_path) as lib_path then
						put (lib_path + ":" + bin_dir, Var_library_path)
					else
						put (bin_dir, Var_library_path)
					end
				end
			end
		end

feature {NONE} -- Constants

	Architecture_bits: INTEGER
		local
			cpu_bits_in: PLAIN_TEXT_FILE
		once
			create cpu_bits_in.make_with_name (Directory.temporary + "lscpu_head_1")
			system ("lscpu | head -n 1 > " + cpu_bits_in.path.name)
			cpu_bits_in.open_read
			cpu_bits_in.read_line
			if cpu_bits_in.last_string.ends_with ((64).out) then
				Result := 64
			else
				Result := 32
			end
			cpu_bits_in.delete
		end

	Data_dir_name_prefix: ZSTRING
		once
			Result := "."
		end

	Open_url_command: ZSTRING
		once
			Result := "xdg-open "
		end

	User_configuration_directory_name: ZSTRING
		once
			Result := ".config"
		end

	Var_library_path: STRING = "LD_LIBRARY_PATH"

end