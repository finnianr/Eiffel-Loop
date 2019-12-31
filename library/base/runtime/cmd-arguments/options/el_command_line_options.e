note
	description: "Base class for reflective command line options with associated help texts"
	notes: "[
		Each boolean attribute maps to a command line word option of the same name.
		If the word-option exists, the attibute is set to `True'
		
		*Help Text*
		
		If the help text is not implemented as an empty string, then it should be formatted as
		a series of option names ending with `:', and the description indented by 1 tab on the next
		line. See [$source EL_BASE_COMMAND_OPTIONS] for an example.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-31 12:02:46 GMT (Tuesday 31st December 2019)"
	revision: "13"

deferred class
	EL_COMMAND_LINE_OPTIONS

inherit
	EL_REFLECTIVE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		export
			{NONE} all
		end

	EL_MODULE_ARGS

	EL_MODULE_TUPLE

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Initialization

	make
		do
			across field_table as field loop
				if attached {EL_REFLECTED_BOOLEAN} field.item as option then
					option.set (Current, Args.word_option_exists (option.name))
				end
			end
		ensure
			valid_help_table: valid_help_table
			valid_names: valid_name_tuple
		end

feature -- Access

	help_table: EL_HASH_TABLE [ZSTRING, STRING]
		local
			lines: EL_ZSTRING_LIST; line, text: ZSTRING
			table: like field_table
		do
			if help_text.is_empty then
				create Result
			else
				table := field_table
				create lines.make_with_lines (help_text)
				create Result.make_equal (lines.count // 2)
				from lines.start until lines.after loop
					line := lines.item
					if line.ends_with (character_string (':'))
						and then not line.starts_with (character_string ('%T'))
					then
						line.remove_tail (1)
						if table.has_key (line) and then lines.index < lines.count then
							text := lines [lines.index + 1]
							text.prune_all_leading ('%T')
							Result.extend (text, line)
						end
					end
					lines.forth
				end
			end
		end

feature {NONE} -- Contract Support

	valid_help_table: BOOLEAN
		local
			table: like help_table
		do
			table := help_table
			if table.is_empty then
				Result := True
			else
				Result := across field_table as entry all table.has_key (entry.key) end
			end
		end

	valid_name_tuple: BOOLEAN
		-- `True' if all names in `Name' match an attribute name
		local
			list: EL_STRING_8_LIST
			table: like field_table
		do
			table := field_table
			create list.make_from_tuple (Name)
			Result := across list as l_name all table.has_key (l_name.item)  end
		end

feature {NONE} -- Implementation

	help_text: READABLE_STRING_GENERAL
		deferred
		end

	Name: TUPLE
		-- accessible names for attributes
		once
			create Result
		end

end
