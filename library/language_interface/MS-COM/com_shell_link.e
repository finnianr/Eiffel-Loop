note
	description: "[
		Wraps
		[https://docs.microsoft.com/en-us/windows/win32/api/shobjidl_core/nn-shobjidl_core-ishelllinkw IShellLinkW]
		COM interface
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-01 16:56:37 GMT (Monday 1st January 2024)"
	revision: "14"

class
	COM_SHELL_LINK

inherit
	COM_OBJECT
		export
			{COM_PERSIST_FILE} self_ptr
		redefine
			make
		end

	COM_WINDOWS_SHELL_API

	EL_ZSTRING_ROUTINES_IMP

create
	make, make_from_path

feature {NONE}  -- Initialization

	make
			-- Creation
		local
			shell_ptr: POINTER
		do
			Precursor
			if c_create_IShellLinkW ($shell_ptr) = status_ok then
				make_from_pointer (shell_ptr)
			end
		end

	make_from_path (file_path: FILE_PATH)
		require
			file_exists: file_path.exists
		do
			make
			if attached new_persist_file as file then
				file.load (file_path)
			end
		end

feature -- Access

	arguments: ZSTRING
		-- command arguments
		do
			Result := new_string (agent cpp_get_arguments, info_tip_size)
		end

	description: ZSTRING
		do
			Result := new_string (agent cpp_get_description, info_tip_size)
		end

	icon: TUPLE [file_path: FILE_PATH; index: INTEGER]
		local
			l_index: INTEGER
		do
			create Result
			Result.file_path := new_string (agent cpp_get_icon_location (?, ?, ?, $l_index), max_path)
			Result.index := l_index + 1
			Result.compare_objects
		end

	target_path: FILE_PATH
		do
			Result := new_string (agent cpp_get_path, max_path)
		end

	working_directory: DIR_PATH
		do
			Result := new_string (agent cpp_get_working_directory, max_path)
		end

feature -- Status query

	is_elevated: BOOLEAN
		-- when `True' the saved link allows launching with elevated priveleges

feature -- Status change

	set_elevated (enabled: BOOLEAN)
		do
			is_elevated := enabled
		end

feature -- Basic operations

	save (file_path: FILE_PATH)
		require
			valid_extension: file_path.extension ~ Extension_lnk
		do
			if attached new_persist_file as file then
				file.save (file_path)
			end
			if is_elevated then
				enable_elevated (file_path)
			end
		end

feature -- Element change

	set_arguments (a_arguments: READABLE_STRING_GENERAL)
		-- set command arguments
		do
			Native_string.set_string (a_arguments)
			last_status := cpp_set_arguments (self_ptr, Native_string.item)
		end

	set_description (a_description: READABLE_STRING_GENERAL)
		do
			Native_string.set_string (a_description)
			last_status := cpp_set_description (self_ptr, Native_string.item)
		end

	set_icon (a_icon: like icon)
		require
			file_exists: a_icon.file_path.exists
		do
			Native_string.set_string (a_icon.file_path)
			last_status := cpp_set_icon_location (self_ptr, Native_string.item, a_icon.index - 1)
		end

	set_target_path (a_target_path: FILE_PATH)
			--
		require
			file_exists: a_target_path.exists
		do
			Native_string.set_string (a_target_path)
			last_status := cpp_set_path (self_ptr, Native_string.item)
		end

	set_working_directory (directory_path: DIR_PATH)
			--
		do
			Native_string.set_string (directory_path)
			last_status := cpp_set_working_directory (self_ptr, Native_string.item)
		end

feature {NONE} -- Implementation

	enable_elevated (file_path: FILE_PATH)
		-- hack to update the link's byte to indicate that shell_ptr is an admin shortcut requiring elevated priveleges.
		-- Original C# code
		-- using (FileStream fs = new FileStream (shortcutPath, FileMode.Open, FileAccess.ReadWrite))
		-- {
		--		fs.Seek(21, SeekOrigin.Begin);
		--		fs.WriteByte(0x22);
		-- }
		local
			file: RAW_FILE
		do
			create file.make_open_read_write (file_path)
			file.go (21)
			file.put_integer_8 (0x22)
			file.close
		end

	new_persist_file: COM_PERSIST_FILE
		local
			file_ptr: POINTER
		do
			if cpp_create_persist_file (self_ptr, $file_ptr) = status_ok then
				create Result.make (file_ptr)
			else
				create Result.make_default
			end
		end

feature -- Constants

	Extension_lnk: ZSTRING
		once
			Result := "lnk"
		end

end