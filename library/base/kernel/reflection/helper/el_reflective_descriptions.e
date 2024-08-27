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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-27 13:06:51 GMT (Tuesday 27th August 2024)"
	revision: "11"

deferred class
	EL_REFLECTIVE_DESCRIPTIONS

inherit
	EL_REFLECTIVE_I

feature -- Access

	description_table: EL_HASH_TABLE [TUPLE [description: ZSTRING; default_value: ANY], IMMUTABLE_STRING_8]
		-- table of descriptions and default values derived from `help_text' and `default' option values
		local
			help_table: EL_IMMUTABLE_UTF_8_TABLE
		do
			if descriptions.is_empty then
				create Result
			elseif attached current_reflective as l_current then
				create help_table.make ({EL_TABLE_FORMAT}.Indented_eiffel, descriptions)
				create Result.make_equal (help_table.count)
				across help_table as table loop
					if field_table.has_immutable_key (table.key) then
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
		do
			if attached description_table as table then
				Result := not table.is_empty implies across field_table as entry all table.has_key (entry.key) end
			end
		end

feature {NONE} -- Deferred implementation

	descriptions: READABLE_STRING_GENERAL
		-- description of attributes
		deferred
		end

	field_table: EL_FIELD_TABLE
		deferred
		end

end