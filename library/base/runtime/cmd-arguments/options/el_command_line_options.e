note
	description: "[
		Base class for reflectively settable command line options with associated help texts
	]"
	notes: "[
		Each class attribute maps to a command line word option of the same name.
		For `BOOLEAN' attributes, if the word-option exists, the attibute is set to `True'
		For other types, the value is set to the next command line argument following the
		word option.
		
		**Default values**
		
		Redefine `initialize_fields' to set default values, accessible via `default'.

		**Help Text**
		
		The `help_table' function converts the text from `help_text' into a table of tuples each
		containing a description and the default value. A usage example can be seen in
		command line help system found in class [$source EL_SUB_APPLICATION].

		If the help text is not implemented as an empty string, then it should be formatted as
		a series of option names ending with `:', and the description indented by 1 tab on the next
		line. See [$source EL_BASE_COMMAND_OPTIONS] for an example.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-01 14:29:05 GMT (Wednesday 1st January 2020)"
	revision: "15"

deferred class
	EL_COMMAND_LINE_OPTIONS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			default as any_default,
			export_name as export_default,
			import_name as import_default
		export
			{NONE} all
			{ANY} print_fields
		end

	EL_MODULE_ARGS
		rename
			default as any_default
		end

	EL_MODULE_TUPLE
		rename
			default as any_default
		end

	EL_ZSTRING_CONSTANTS
		rename
			default as any_default
		end

feature {NONE} -- Initialization

	make
		-- make object with attributes initialized from corresponding command line options
		do
			make_default
			across field_table as field loop
				field.item.set_from_command_line (Current, Args)
			end
		ensure
			valid_help: not help_text.is_empty implies valid_help_table
			valid_names: Tuple.to_string_8_list (Name).for_all (agent is_option)
		end

feature -- Access

	default: like Current
		deferred
		end

	help_table: EL_HASH_TABLE [TUPLE [description: ZSTRING; default_value: ANY], STRING]
		-- table of descriptions and default values derived from `help_text' and `default' option values
		local
			lines: EL_ZSTRING_LIST; line, text: ZSTRING
			l_default: like default
		do
			if help_text.is_empty then
				create Result
			else
				l_default := default
				create lines.make_with_lines (help_text)
				create Result.make_equal (lines.count // 2)
				from lines.start until lines.after loop
					line := lines.item
					if line.ends_with (character_string (':'))
						and then not line.starts_with (character_string ('%T'))
					then
						line.remove_tail (1)
						if field_table.has_key (line) and then lines.index < lines.count then
							text := lines [lines.index + 1]
							text.prune_all_leading ('%T')
							Result.extend ([text, field_table.found_item.value (default)], line)
						end
					end
					lines.forth
				end
			end
		ensure
			complete: across field_table as entry all Result.has_key (entry.key) end
		end

feature -- Status query

	is_option (a_name: STRING): BOOLEAN
		do
			Result := field_table.has_key (a_name)
		end

feature {NONE} -- Contract Support

	valid_help_table: BOOLEAN
		-- `True' if `help_table' is complete
		local
			table: like help_table
		do
			table := help_table
			Result := not table.is_empty implies across field_table as entry all table.has_key (entry.key) end
		end

feature {NONE} -- Deferred implementation

	help_text: READABLE_STRING_GENERAL
		deferred
		end

feature {NONE} -- Constants

	Name: TUPLE
		-- accessible names for attributes
		once
			create Result
		ensure
			valid_names: Tuple.to_string_8_list (Result).for_all (agent is_option)
		end

	New_line: STRING = "%N"

note
	descendants: "[
			EL_COMMAND_LINE_OPTIONS*
				[$source EL_LOG_COMMAND_OPTIONS]
				[$source EL_BASE_COMMAND_OPTIONS]
				[$source EL_APPLICATION_COMMAND_OPTIONS]
					[$source TEST_WORK_DISTRIBUTER_COMMAND_OPTIONS]
	]"
end
