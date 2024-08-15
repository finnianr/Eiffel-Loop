note
	description: "Application mutex to create an application singleton"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-15 14:44:19 GMT (Thursday 15th August 2024)"
	revision: "13"

class
	EL_APPLICATION_MUTEX

inherit
	ANY

	EL_MODULE_BUILD_INFO

	EL_CHARACTER_32_CONSTANTS

	EL_STRING_GENERAL_ROUTINES

	EL_MODULE_DIRECTORY; EL_MODULE_FILE_SYSTEM

create
	make, make_for_application_mode

feature {NONE} -- Implementation

	make
		do
			name := new_lock_name (Empty_string)
			try_lock
		end

	make_for_application_mode (option_name: READABLE_STRING_GENERAL)
			-- Create mutex for application in mode specified by option_name
		do
			name := new_lock_name (ZSTRING (option_name))
			try_lock
		end

feature -- Status change

	try_lock
		local
			mutex: EL_NAMED_FILE_LOCK
		do
			create mutex.make (locked_file_path)
			mutex.try_lock
			if mutex.is_locked then
				is_locked := True
				file_mutex := mutex
			end
		end

	unlock
		require
			is_locked: is_locked
		do
			if attached file_mutex as mutex then
				mutex.unlock
				is_locked := mutex.is_locked
				if not is_locked then
					mutex.close
					file_mutex := Void
					File_system.remove_file (locked_file_path)
				end
			end
		end

feature -- Status query

	is_locked: BOOLEAN
		-- Is this the only instance of this application

feature {NONE} -- Implementation

	locked_file_path: FILE_PATH
		do
			Result := Lock_dir + name
		end

	new_lock_name (option: ZSTRING): ZSTRING
		-- eg. "Hex_11_Software_My_Ching.main.lock"
		local
			characters, underscores: STRING; list: EL_ZSTRING_LIST
		do
			characters := "\/ "; underscores := underscore * characters.count
			create list.make_from_array (<<
				Build_info.installation_sub_directory.to_string.translated (characters, underscores),
				option, "lock"
			>>)
			list.prune_all_empty -- option might be empty
			Result := list.joined ('.')
		end

feature {NONE} -- Internal attributes

	file_mutex: detachable EL_NAMED_FILE_LOCK

	name: ZSTRING

feature {NONE} -- Constants

	Lock_dir: DIR_PATH
		once
			if {PLATFORM}.is_windows then
				Result := Directory.temporary
			else
			-- does not require root permissions to write file in this directory
				Result := "/run/lock"
			end
		end
end