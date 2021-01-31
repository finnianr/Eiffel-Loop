note
	description: "Execution environment i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-31 15:48:13 GMT (Sunday 31st January 2021)"
	revision: "20"

deferred class
	EL_EXECUTION_ENVIRONMENT_I

inherit
	EXECUTION_ENVIRONMENT
		rename
			sleep as sleep_nanosecs,
			current_working_directory as current_working_directory_obselete
		redefine
			item, launch, put, system
		end

	EL_MODULE_ARGS
		export
			{NONE} all
		end

	EL_SHARED_OPERATING_ENVIRON
		export
			{NONE} all
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_EXECUTABLE

	EL_MODULE_EXCEPTION

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

feature {EL_MODULE_EXECUTION_ENVIRONMENT} -- Initialization

	make
		do
			last_code_page := console_code_page
		end

feature -- Access

	architecture_bits: INTEGER
		deferred
		end

	console_code_page: NATURAL
			-- For windows. Returns 0 in Unix
		deferred
		end

	data_dir_name_prefix: ZSTRING
		deferred
		end

	item (key: READABLE_STRING_GENERAL): detachable STRING_32
		local
			s: EL_ZSTRING_ROUTINES
		do
			if attached Precursor (s.to_unicode_general (key)) as value and then not value.is_empty then
				Result := value
			end
			-- returns void if value is empty in order to satisfy postcondition on `put'
		end

	user_configuration_directory_name: ZSTRING
			--
		deferred
		end

	variable_dir_path (name: READABLE_STRING_GENERAL): EL_DIR_PATH
		do
			if attached {STRING_32} item (name) as environ_path then
				Result := environ_path
			else
				create Result
			end
		end

	last_code_page: NATURAL
		-- last windows code page

feature -- Basic operations

	clear_screen
		do
			system (Operating_environ.clear_screen_command)
		end

	exit (code: INTEGER)
		do
			Exception.general.die (code)
		end

	launch (cmd: READABLE_STRING_GENERAL)
		local
			s: EL_ZSTRING_ROUTINES
		do
			-- NATIVE_STRING calls {READABLE_STRING_GENERAL}.code
			Precursor (s.to_unicode_general (cmd))
		end

	sleep (millisecs: DOUBLE)
			--
		do
			sleep_nanosecs ((millisecs * Nanosecs_per_millisec).truncated_to_integer_64)
		end

	system (cmd: READABLE_STRING_GENERAL)
		local
			s: EL_ZSTRING_ROUTINES
		do
			-- NATIVE_STRING calls {READABLE_STRING_GENERAL}.code
			Precursor (s.to_unicode_general (cmd))
		end

	pop_current_working
		require
			valid_directory_stack_empty: not is_directory_stack_empty
		do
			change_working_path (directory_stack.item)
			directory_stack.remove
		end

	push_current_working (a_dir: EL_DIR_PATH)
		do
			directory_stack.put (current_working_path)
			change_working_path (a_dir)
		end

	open_url (url: EL_FILE_URI_PATH)
		 -- open the URL in the default system browser
		deferred
		end

feature -- Status report

	is_directory_stack_empty: BOOLEAN
		do
			Result := directory_stack.is_empty
		end

feature -- Status setting

	put (value, key: READABLE_STRING_GENERAL)
		local
			s: EL_ZSTRING_ROUTINES
		do
			Precursor (s.to_unicode_general (value), s.to_unicode_general (key))
		end

	restore_last_code_page
			-- Restore original Windows console code page
			-- WINDOWS ONLY, Unix has no effect.

			-- Use on program exit in case utf_8_console_output is set
		do
			set_console_code_page (last_code_page)
		end

	set_utf_8_console_output
			-- Set Windows console to utf-8 code page (65001)
			-- WINDOWS ONLY, Unix has no effect.

			-- WARNING
			-- If the original code page is not restored on program exit after changing to 65001 (utf-8)
			-- this could effect subsequent programs that run in the same shell.
			-- Python scripts for example, might give a "LookupError: unknown encoding: cp65001".

		do
		end

feature -- Transformation

	application_dynamic_module_path (module_name: STRING): EL_FILE_PATH
		do
			Result := Directory.Application_bin + dynamic_module_name (module_name)
		end

	dynamic_module_name (module_name: READABLE_STRING_GENERAL): ZSTRING
			-- normalized name for platform
			-- name = "svg"
			-- 	Linux: Result = "libsvg.so"
			-- 	Windows: Result = "svg.dll"
		do
			create Result.make (module_name.count + 7)
			Result.append_string_general (Operating_environ.C_library_prefix)
			Result.append_string_general (module_name)
			Result.append_character ('.')
			Result.append_string_general (Operating_environ.Dynamic_module_extension)
		end

feature {NONE} -- Implementation

	set_console_code_page (code_page_id: NATURAL)
			-- For windows commands. Does nothing in Unix
		deferred
		end

feature -- Constants

	Directory_stack: ARRAYED_STACK [EL_DIR_PATH]
		once
			create Result.make (1)
		end

	Nanosecs_per_millisec: INTEGER_64 = 1000_000

end