note
	description: "Application mutex to create an application singleton"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 13:50:43 GMT (Sunday 30th March 2025)"
	revision: "17"

class
	EL_APPLICATION_MUTEX

inherit
	EL_NAMED_FILE_LOCK
		rename
			make as make_for_path
		end

	EL_MODULE_BUILD_INFO

	EL_CHARACTER_32_CONSTANTS

	EL_STRING_GENERAL_ROUTINES_I

	EL_MODULE_DIRECTORY

	EL_ZSTRING_CONSTANTS

create
	make, make_for_application_mode

feature {NONE} -- Implementation

	make
		do
			make_for_application_mode (Empty_string)
		end

	make_for_application_mode (option_name: READABLE_STRING_GENERAL)
		-- Create mutex for application in mode specified by option_name
		-- eg. "Hex_11_Software_My_Ching.main.lock"
		local
			characters, underscores: STRING; list: EL_ZSTRING_LIST
		do
			characters := "\/ "; underscores := underscore * characters.count
			create list.make_from_array (<<
				Build_info.installation_sub_directory.to_string.translated (characters, underscores),
				as_zstring (option_name), "lock"
			>>)
			list.prune_all_empty -- option might be empty

			make_for_path (Lock_dir + list.joined ('.'))
		end

feature -- Basic operations

	try_remove
		-- remove if the mutex is owned
		do
			if is_locked then
				unlock; remove_file
			end
		ensure
			file_removed: not is_writeable and then old is_locked implies not path.exists
		end

feature {NONE} -- Constants

	Lock_dir: DIR_PATH
		once
			if {PLATFORM}.is_windows then
				Result := Directory.temporary
			else
			-- does not require root permissions to write files in this directory
				Result := "/run/lock"
			end
		end
end