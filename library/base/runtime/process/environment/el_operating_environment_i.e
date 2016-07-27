note
	description: "Summary description for {EL_OPERATING_ENVIRONMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-01 9:11:07 GMT (Friday 1st July 2016)"
	revision: "6"

deferred class
	EL_OPERATING_ENVIRONMENT_I

inherit
	OPERATING_ENVIRONMENT

	EL_MODULE_DIRECTORY

feature -- Access

	clear_screen_command: STRING
		deferred
		end

	C_library_prefix: STRING
		deferred
		end

	command_option_prefix: CHARACTER
			-- Character used to prefix option in command line
		deferred
		end

	dynamic_module_extension: STRING
		deferred
		end

	search_path_separator: CHARACTER
			-- Character used to separate paths in a directorysearch path on this platform.
		deferred
		end

	temp_directory_name: ZSTRING
		deferred
		end

feature -- Constants

	Temp_directory_path: EL_DIR_PATH
			--
		once
			create Result.make_from_unicode (temp_directory_name)
		end

feature -- Measurement

	is_root_path (path: STRING): BOOLEAN
			--
		deferred
		end

end