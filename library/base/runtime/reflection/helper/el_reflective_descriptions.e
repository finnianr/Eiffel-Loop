note
	description: "Object to map textual descriptions in `description' to attributes"
	notes: "[
		**Descriptive Text Format**

		The `description_table' function converts the text from `descriptions' into a table of tuples each
		containing a description of an attribute and the initialized value.
		The format is illustrated by the following example:
		
			DBC:
				Design by contract
			CQS:
				Command query separation
				
		The attribute name should match the field names created by calls to `export_name' in the descendant.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 20:09:22 GMT (Monday 13th January 2020)"
	revision: "1"

deferred class
	EL_REFLECTIVE_DESCRIPTIONS

inherit
	EL_REFLECTIVE_I
		undefine
			is_equal
		end

	EL_ZSTRING_CONSTANTS

feature -- Access

	description_table: EL_HASH_TABLE [TUPLE [description: ZSTRING; default_value: ANY], STRING]
		-- table of descriptions and default values derived from `help_text' and `default' option values
		local
			lines: EL_ZSTRING_LIST; line, text: ZSTRING
			l_current: like current_reflective
		do
			if descriptions.is_empty then
				create Result
			else
				l_current := current_reflective
				create lines.make_with_lines (descriptions)
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
							Result.extend ([text, field_table.found_item.value (l_current)], line)
						end
					end
					lines.forth
				end
			end
		ensure
			complete: across field_table as entry all Result.has_key (entry.key) end
		end

feature {NONE} -- Contract Support

	valid_description_table: BOOLEAN
		-- `True' if `description_table' is complete
		local
			table: like description_table
		do
			table := description_table
			Result := not table.is_empty implies across field_table as entry all table.has_key (entry.key) end
		end

feature {NONE} -- Deferred implementation

	descriptions: READABLE_STRING_GENERAL
		-- description of attributes
		deferred
		end

	field_table: EL_REFLECTED_FIELD_TABLE
		deferred
		end

end
