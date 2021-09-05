note
	description: "Operating System command interface"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 11:08:02 GMT (Wednesday 1st September 2021)"
	revision: "22"

deferred class
	EL_OS_COMMAND_I

inherit
	EL_COMMAND

	EVOLICITY_SERIALIZEABLE_AS_ZSTRING
		rename
			as_text as system_command
		redefine
			make_default, system_command
		end

	EL_REFLECTIVE
		rename
			export_name as export_default,
			import_name as import_default,
			field_included as is_path_or_boolean_field
		export
			{NONE} all
		redefine
			Transient_fields
		end

	EL_OS_COMMAND_CONSTANTS

	EL_SHARED_CLASS_ID

	EL_MODULE_DIRECTORY

	EL_MODULE_EXECUTABLE

	EL_MODULE_LIO

	EL_ZSTRING_CONSTANTS

	EL_SHARED_OPERATING_ENVIRON

feature {NONE} -- Initialization

	make_default
			--
		do
			create working_directory
			errors := Empty_list
			Precursor
		end

feature -- Access

	errors: EL_ZSTRING_LIST

	working_directory: EL_DIR_PATH

feature -- Element change

	set_working_directory (a_working_directory: like working_directory)
			--
		do
			working_directory := a_working_directory
		end

feature -- Status query

	back_quotes_escaped: BOOLEAN
			-- If true, back quote characters ` are escaped on posix platforms
			-- This means that commands that use BASH back-quote command substitution cannot be used
			-- without first making sure that individual path operands are escaped
		do
			Result := not {PLATFORM}.is_windows
		end

	dry_run_enabled: BOOLEAN
		-- when `true' command will just print to screen without executing

	has_error: BOOLEAN
		-- True if the command returned an error code on exit

	is_forked: BOOLEAN
		-- `true' if command executes asynchronously in another system process

	is_valid_platform: BOOLEAN
		do
			Result := True
		end

feature -- Status change

	set_forking_mode (forked: BOOLEAN)
		-- when `forked' is `True', execution happens in another process
		do
			is_forked := forked
		end

	set_dry_run (enabled: BOOLEAN)
		do
			dry_run_enabled := enabled
		end

feature -- Basic operations

	execute
			--
		require else
			valid_platform: is_valid_platform
		local
			l_command: like system_command
		do
			reset
			l_command := system_command
			if l_command.is_empty then
				lio.put_string_field ("Error in command template", generator)
				lio.put_new_line
			else
				if dry_run_enabled or else is_lio_enabled then
					display (l_command.lines)
				end
				if not dry_run_enabled then
					l_command.translate_and_delete (Tab_and_new_line, Null_and_space)
					do_command (l_command)
				end
			end
		end

feature {NONE} -- Evolicity reflection

	get_boolean_ref (field: EL_REFLECTED_BOOLEAN_REF): BOOLEAN_REF
		do
			Result := field.value (Current)
		end

	to_boolean_ref (field: EL_REFLECTED_BOOLEAN): BOOLEAN_REF
		do
			Result := field.value (Current).to_reference
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make_size (11)
			across meta_data.field_list as list loop
				if attached {EL_REFLECTED_BOOLEAN} list.item as field then
					Result [field.name] := agent to_boolean_ref (field)

				elseif attached {EL_REFLECTED_BOOLEAN_REF} list.item as field
					and then field.type_id = Class_id.EL_BOOLEAN_OPTION
				then
					Result [field.name + Enabled_suffix] := agent get_boolean_ref (field)
				end
			end
		end

feature {NONE} -- Implementation

	display (lines: LIST [ZSTRING])
			-- display word wrapped command
		local
			current_working_directory, printable_line, name, prompt, blank_prompt: ZSTRING
			max_width: INTEGER; words: EL_SEQUENTIAL_INTERVALS
		do
			current_working_directory := Directory.current_working
			name := generator
			if name.starts_with (EL_prefix) then
				name.remove_head (3)
			end
			if name.ends_with (Command_suffix) then
				name.remove_tail (8)
			end
			name.replace_character ('_', ' ')
			create blank_prompt.make_filled (' ', name.count)
			prompt := name

			max_width := 100 - prompt.count  - 2

			create printable_line.make (200)
			across lines as line loop
				line.item.replace_substring_all (current_working_directory, Variable_cwd)
				line.item.left_adjust
				words := line.item.split_intervals (character_string (' '))
				from words.start until words.after loop
					if words.item_count > 0 then
						if not printable_line.is_empty then
							printable_line.append_character (' ')
						end
						printable_line.append_substring (line.item, words.item_lower, words.item_upper)
						if printable_line.count > max_width then
							printable_line.remove_tail (words.item_count)
							lio.put_labeled_string (prompt, printable_line)
							lio.put_new_line
							printable_line.wipe_out
							printable_line.append_substring (line.item, words.item_lower, words.item_upper)
							prompt := blank_prompt
						end
					end
					words.forth
				end
			end
			lio.put_labeled_string (prompt, printable_line)
			lio.put_new_line
		end

	do_command (a_system_command: like system_command)
			--
		local
			command_parts: EL_ZSTRING_LIST; error_path: EL_FILE_PATH
		do
			if is_forked then
				Execution_environment.launch (a_system_command)
			else
				if not working_directory.is_empty then
					Execution_environment.push_current_working (working_directory)
				end
				create command_parts.make_from_array (new_command_parts (a_system_command))
				command_parts.prune_all_empty -- `command_prefix' is empty on Unix

				error_path := temporary_error_file_path
				File_system_mutex.lock
					File_system.make_directory (error_path.parent)
				File_system_mutex.unlock

				Execution_environment.system (command_parts.joined_words)

				set_has_error (Execution_environment.return_code)
				if not working_directory.is_empty then
					Execution_environment.pop_current_working
				end
				if has_error then
					create errors.make (5)
					new_output_lines (error_path).do_all (agent errors.extend)
					on_error
				end
				File_system_mutex.lock
					if error_path.exists then
						File_system.remove_file (error_path)
					end
				File_system_mutex.unlock
			end
		end

	is_path_or_boolean_field (basic_type, type_id: INTEGER): BOOLEAN
		-- when True, include field of this type in `field_table' and `meta_data'
		-- except when the name is one of those listed in `Except_fields'.
		do
			inspect basic_type
				when {REFLECTOR_CONSTANTS}.Boolean_type then
					Result := True
				when {REFLECTOR_CONSTANTS}.Reference_type then
					Result := Eiffel.type_conforms_to (type_id, Class_id.EL_PATH)
						or else Eiffel.type_conforms_to (type_id, Class_id.EL_BOOLEAN_OPTION)
			else
			end
		end

	on_error
		do
		end

	reset
			-- Executed before do_command
		do
			errors := Empty_list
			has_error := False
		end

	set_has_error (return_code: INTEGER)
		do
			has_error := return_code /= 0
		end

	system_command: ZSTRING
		do
			Result := Precursor
			Result.left_adjust
		end

	temporary_error_file_path: EL_FILE_PATH
		do
			Result := Temporary_error_path_by_type.item (Current)
		end

feature {EL_OS_COMMAND_I} -- Factory

	new_command_parts (a_system_command: like system_command): ARRAY [ZSTRING]
		do
			Result := <<
				command_prefix, a_system_command, Error_redirection_operator, temporary_error_file_path
			>>
		end

	new_temporary_file_path (a_extension: STRING): EL_FILE_PATH
		-- uniquely numbered temporary file in temporary area set by env label "TEMP"
		do
			Result := Temporary_path_format #$ [
				Operating_environ.temp_directory_name, Executable.user_qualified_name,
				new_temporary_name, once "00." + a_extension
			]
			-- check if directory already exists with root ownership (perhaps created by installer program)
			-- (Using sudo command does not mean that the user name changes to root)
			if Result.parent.exists and then not File_system.is_writeable_directory (Result.parent) then
				Result.set_parent_path (Result.parent.to_string + "-2")
			end
			Result := Result.next_version_path
		end

	new_temporary_name: ZSTRING
		do
			Result := generator
			Result.enclose ('{', '}')
		end

feature {NONE} -- Deferred implementation

	command_prefix: STRING_32
			-- For Windows to force unicode output using "cmd /U /C"
			-- Empty in Unix
		deferred
		end

	new_output_lines (file_path: EL_FILE_PATH): EL_LINEAR [ZSTRING]
		deferred
		end

	template: READABLE_STRING_GENERAL
			--
		deferred
		end

feature {NONE} -- Constants

	Temporary_error_path_by_type: EL_FUNCTION_RESULT_TABLE [EL_OS_COMMAND_I, EL_FILE_PATH]
		once
			create Result.make (17, agent {EL_OS_COMMAND_I}.new_temporary_file_path ("err"))
		end

	Transient_fields: STRING
		once
			Result := "dry_run_enabled, is_forked, has_error"
		end

note
	notes: "[
		**Routine getter_function_table**
		
		This routine automatically adds the following field types to the table
		
		1. [$source EL_BOOLEAN_OPTION] will be added with the modified name: `<field-name>_enabled'

		2. [$source BOOLEAN] fields will be added with the field name as is.
	]"

end