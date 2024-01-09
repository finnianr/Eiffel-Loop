note
	description: "Execution environment i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 11:11:08 GMT (Sunday 7th January 2024)"
	revision: "35"

deferred class
	EL_EXECUTION_ENVIRONMENT_I

inherit
	EXECUTION_ENVIRONMENT
		rename
			item as item_32,
			sleep as sleep_nanosecs,
			current_working_directory as current_working_directory_obselete
		redefine
			item_32, launch, put, system
		end

	EL_OS_DEPENDENT

	EL_MEMORY_ROUTINES

	EL_STRING_GENERAL_ROUTINES

	STRING_HANDLER

	EL_MODULE_ARGS; EL_MODULE_EXECUTABLE; EL_MODULE_EXCEPTION; EL_MODULE_DIRECTORY

	EL_SHARED_STRING_32_BUFFER_SCOPES; EL_SHARED_NATIVE_STRING

	EL_SHARED_OPERATING_ENVIRON
		export
			{NONE} all
		end

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

	item (key: READABLE_STRING_GENERAL): detachable ZSTRING
		require
			not_has_null_character: not key.has ('%U')
		local
			c_item: POINTER
		do
			Native_string.set_string (key)
			c_item := eif_getenv (Native_string.item)
			if is_attached (c_item) and then attached new_native_string (c_item) as native
				and then native.count > 0
			then
				Result := native.to_string
			end
		end

	item_32 (key: READABLE_STRING_GENERAL): detachable STRING_32
		do
			if attached Precursor (key) as value and then not value.is_empty then
				Result := value
			end
			-- returns void if value is empty in order to satisfy postcondition on `put'
		end

	language_code: STRING
		-- Two letter code representing user language
		-- Example: "en" is English
		do
			Result := new_language_code
			if not (Result.count = 2 and across Result as letter all letter.item.is_lower end) then
				Result := "en"
			end
		end

	last_code_page: NATURAL
		-- last windows code page

	user_configuration_directory_name: ZSTRING
			--
		deferred
		end

	variable_dir_path (name: READABLE_STRING_GENERAL): DIR_PATH
		do
			if attached item (name) as environ_path then
				Result := environ_path
			else
				create Result
			end
		end

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
		do
			do_system_call (cmd, False)
		end

	open_url (url: EL_FILE_URI_PATH)
		 -- open the URL in the default system browser
		deferred
		end

	pop_current_working
		require
			valid_directory_stack_empty: not is_directory_stack_empty
		do
			change_working_path (Directory_stack.item)
			directory_stack.remove
		end

	push_current_working (a_dir: DIR_PATH)
		do
			directory_stack.put (current_working_path)
			change_working_path (a_dir)
		end

	set_library_path
		-- add build/$ISE_PLATFORM/package/bin to LD_LIBRARY_PATH for Unix platform
		deferred
		end

	sleep (millisecs: DOUBLE)
			--
		do
			sleep_nanosecs ((millisecs * Nanosecs_per_millisec).truncated_to_integer_64)
		end

	system (cmd: READABLE_STRING_GENERAL)
		do
			do_system_call (cmd, True)
		end

feature -- Status report

	is_directory_stack_empty: BOOLEAN
		do
			Result := directory_stack.is_empty
		end

feature -- Status setting

	put (value, key: READABLE_STRING_GENERAL)
		local
			s32: EL_STRING_32_ROUTINES; c_env: NATIVE_STRING; l_key: IMMUTABLE_STRING_32
		do
			across String_32_scope as scope loop
				if attached scope.best_item (value.count + key.count + 1) as str then
					s32.append_to (str, key)
					str.append_character ('=')
					s32.append_to (str, value)
					create c_env.make (str)
				end
			end
			create l_key.make_from_string_general (to_unicode_general (key))
			environ.force (c_env, l_key)
			return_code := eif_putenv (c_env.item)
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

feature {NONE} -- Implementation

	do_system_call (cmd: READABLE_STRING_GENERAL; wait_to_return: BOOLEAN)
		do
			if attached Native_string as c_str then
				if cmd.is_empty then
					c_str.set_string (default_shell)
				else
					c_str.set_string (cmd)
				end
				if wait_to_return then
					return_code := system_call (c_str.item)
				else
					asynchronous_system_call (c_str.item)
				end
			end
		end

	new_language_code: STRING
		deferred
		end

	set_console_code_page (code_page_id: NATURAL)
			-- For windows commands. Does nothing in Unix
		deferred
		end

	new_native_string (c_item: POINTER): EL_NATIVE_STRING_8
		require
			attached_item: is_attached (c_item)
		do
			create Result.make_from_c (c_item)
		end

feature -- Constants

	Directory_stack: ARRAYED_STACK [PATH]
		once
			create Result.make (1)
		end

	Nanosecs_per_millisec: INTEGER_64 = 1000_000

end