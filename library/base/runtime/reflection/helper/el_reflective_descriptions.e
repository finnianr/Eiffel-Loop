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
	date: "2020-09-17 10:17:55 GMT (Thursday 17th September 2020)"
	revision: "2"

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
			l_current: like current_reflective; help_table: EL_DESCRIPTION_TABLE
		do
			if descriptions.is_empty then
				create Result
			else
				l_current := current_reflective
				create help_table.make (descriptions)
				create Result.make_equal (help_table.count)
				across help_table as table loop
					if field_table.has_key (table.key) then
						Result.extend ([table.item, field_table.found_item.value (l_current)], table.key)
					end
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