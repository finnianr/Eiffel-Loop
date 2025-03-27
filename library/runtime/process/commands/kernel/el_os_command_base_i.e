note
	description: "Basis for class ${EL_OS_COMMAND_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-27 11:06:16 GMT (Thursday 27th March 2025)"
	revision: "1"

deferred class
	EL_OS_COMMAND_BASE_I

inherit
	EVC_SERIALIZEABLE_AS_ZSTRING
		rename
			as_text as system_command
		export
			{NONE} all
		undefine
			context_item, has_variable
		redefine
			make_default, system_command
		end

	EVC_REFLECTIVE_EIFFEL_CONTEXT
		rename
			escaped_field as unescaped_field
		undefine
			make_default, new_getter_functions
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as eiffel_naming
		export
			{NONE} all
		undefine
			is_equal
		redefine
			make_default, new_transient_fields
		end

	EL_COMMAND

	EL_OS_DEPENDENT

	EL_MODULE_DIRECTORY; EL_MODULE_EXECUTABLE; EL_MODULE_LIO; EL_MODULE_NAMING

	EL_OS_COMMAND_CONSTANTS

	EL_SHARED_OPERATING_ENVIRON

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_REFLECTIVELY_SETTABLE}
			Precursor {EVC_SERIALIZEABLE_AS_ZSTRING}
		end

feature -- Contract Support

	template_has (name: READABLE_STRING_8): BOOLEAN
		-- `True' if `template' has reference to variable `name'
		local
			index: INTEGER
		do
			across << "$", "${" >> as list until Result loop
				if attached list.item as symbol and then attached (symbol + name) as name_reference then
					index := template.substring_index (name_reference, 1)
					if index > 0 then
						index := index + name_reference.count
						inspect symbol.count
							when 2 then
								Result := template.valid_index (index) implies template [index] = '}'
						else
							Result := template.valid_index (index) implies not template [index].is_alpha_numeric
						end
					end
				end
			end
		end

feature {NONE} -- Factory

	new_error: EL_ERROR_DESCRIPTION
		do
			create Result.make_code (Execution_environment.return_code)
		end

	new_temporary_file_path (a_extension: STRING): FILE_PATH
		-- uniquely numbered temporary file in temporary area set by env label "TEMP"
		do
			Result := Temporary_path_format #$ [
				Operating_environ.temp_directory_name, Executable.user_qualified_name,
				new_temporary_name, a_extension
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
		end

feature {NONE} -- Implementation

	display (lines: LIST [ZSTRING])
			-- display word wrapped command
		local
			current_working_directory, printable_line, prompt, blank_prompt: ZSTRING
			max_width, head_count, tail_count: INTEGER; words: EL_ZSTRING_SPLIT_INTERVALS
			name: STRING
		do
			current_working_directory := Directory.current_working
			if attached generating_type as type then
				head_count := if Naming.is_eiffel_loop (type.name) then 1 else 0 end
				tail_count := if type.name.ends_with (Command_suffix) then 1 else 0 end
				name := Naming.class_with_separator (type, ' ', head_count, tail_count)
				create blank_prompt.make_filled (' ', name.count)
				prompt := name
			end

			max_width := 100 - prompt.count  - 2

			create printable_line.make (200)
			across lines as line loop
				line.item.replace_substring_all (current_working_directory, Variable_cwd)
				line.item.left_adjust

				create words.make (line.item, ' ')
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

	new_transient_fields: STRING
		do
			Result := Precursor + "[
				, dry_run, getter_functions, internal_error_list, is_forked,
				has_error, on_encoding_change, encoding_other, output_path, template_path
			]"
		end

	on_error (error: EL_ERROR_DESCRIPTION)
		do
		end

	system_command: ZSTRING
		do
			Result := Precursor
			Result.left_adjust
		end

feature {NONE} -- Evolicity reflection

	get_boolean_option (field: EL_REFLECTED_BOOLEAN_REF): BOOLEAN_REF
		do
			Result := field.value (Current)
		end

	get_escaped_path (field: EL_REFLECTED_PATH): ZSTRING
		do
			Result := field.value (Current).escaped
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (11)
			across field_list as list loop
				if attached list.item as field and then not field.is_expanded then
					if attached {EL_REFLECTED_PATH} field as path_field then
						Result [field.name] := agent get_escaped_path (path_field)

					elseif field.type_id = Class_id.EL_BOOLEAN_OPTION
						and then attached {EL_REFLECTED_BOOLEAN_REF} field as option_field
					then
						Result [field.name + Enabled_suffix] := agent get_boolean_option (option_field)
					end
				end
			end
		end

feature {NONE} -- Deferred implementation

	command_prefix: ZSTRING
		-- For Windows to force unicode output using "cmd /U /C"
		-- Empty in Unix
		deferred
		end

	new_output_lines (file_path: FILE_PATH): EL_PLAIN_TEXT_LINE_SOURCE
		require
			path_exists: file_path.exists
		deferred
		end

	null_redirection: ZSTRING
		deferred
		end

	run_as_administrator (command_parts: EL_ZSTRING_LIST)
		deferred
		end

end