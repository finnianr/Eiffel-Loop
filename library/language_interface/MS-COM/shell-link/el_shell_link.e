note
	description: "Objects that creates a Windows shortcut"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "6"

class
	EL_SHELL_LINK

inherit
	EL_WCOM_OBJECT

	EL_SHELL_LINK_API
		undefine
			dispose
		end

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

	set_command_arguments (command_arguments: EL_ASTRING)
			--
		do
			last_call_result := cpp_set_arguments (self_ptr, wide_string (command_arguments).base_address)
		end

	set_description (description: EL_ASTRING)
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

	Extension_lnk: EL_ASTRING
		once
			Result := "lnk"
		end

end
