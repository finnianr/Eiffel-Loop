note
	description: "Shell link"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	EL_SHELL_LINK

inherit
	EL_WCOM_OBJECT

	EL_SHELL_LINK_API

create
	make

feature {NONE}  -- Initialization

	make
			-- Creation
		local
			this: POINTER
		do
			initialize_library
			if call_succeeded (c_create_IShellLinkW ($this)) then
				make_from_pointer (this)
				persist_file := create_persist_file
			else
				create persist_file
			end
		end

feature -- Basic operations

	save (file_path: EL_FILE_PATH)
			--
		require
			valid_extension: file_path.extension ~ Extension_lnk
		do
			persist_file.save (file_path)
		end

	save_elevated (file_path: EL_FILE_PATH)
		-- hack to update the link's byte to indicate that this is an admin shortcut requiring elevated priveleges.
		local
			shell_link: RAW_FILE
		do
			-- Original C# code
			-- using (FileStream fs = new FileStream (shortcutPath, FileMode.Open, FileAccess.ReadWrite))
			-- {
			--    fs.Seek(21, SeekOrigin.Begin);
			--    fs.WriteByte(0x22);
			-- }

			save (file_path)
			create shell_link.make_open_read_write (file_path)
			shell_link.go (21)
			shell_link.put_integer_8 (0x22)
			shell_link.close
		end

	load (file_path: EL_FILE_PATH)
			--
		require
			file_exists: file_path.exists
		do
			persist_file.load (file_path)
		end

feature -- Element change

	set_target_path (target_path: EL_FILE_PATH)
			--
		require
			file_exists: target_path.exists
		do
			last_call_result := cpp_set_path (self_ptr, wide_string (target_path).base_address)
		end

	set_command_arguments (command_arguments: ZSTRING)
			--
		do
			last_call_result := cpp_set_arguments (self_ptr, wide_string (command_arguments).base_address)
		end

	set_description (description: ZSTRING)
			--
		do
			last_call_result := cpp_set_description (self_ptr, wide_string (description).base_address)
		end

	set_working_directory (directory_path: EL_DIR_PATH)
			--
		do
			last_call_result := cpp_set_working_directory (self_ptr, wide_string (directory_path).base_address)
		end

	set_icon_location (icon_file_path: EL_FILE_PATH; index: INTEGER)
			--
		require
			file_exists: icon_file_path.exists
		do
			last_call_result := cpp_set_icon_location (self_ptr, wide_string (icon_file_path).base_address, index - 1)
		end

feature {NONE} -- Implementation

	create_persist_file: EL_WCOM_PERSIST_FILE
		local
			this: POINTER
		do
			if call_succeeded (cpp_create_IPersistFile (self_ptr, $this)) then
				create Result.make_from_pointer (this)
			else
				create Result
			end
		end

	persist_file: EL_WCOM_PERSIST_FILE

feature -- Constants

	Extension_lnk: ZSTRING
		once
			Result := "lnk"
		end

end
