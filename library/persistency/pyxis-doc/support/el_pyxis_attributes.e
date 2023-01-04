note
	description: "List of Pyxis attribute lines for output to [$source EL_OUTPUT_MEDIUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-03 22:00:58 GMT (Tuesday 3rd January 2023)"
	revision: "4"

class
	EL_PYXIS_ATTRIBUTES

inherit
	FIXED_LIST [HASH_TABLE [ZSTRING, STRING]]
		rename
			make as make_list,
			put as put_table
		export
			{NONE} all
			{ANY} first, last, i_th
		end

	EL_ATTRIBUTE_TYPE_ROUTINES
		export
			{NONE} all
		undefine
			copy, is_equal
		end

	EL_MODULE_PYXIS

create
	make

feature {NONE} -- Initialization

	make
		do
			make_list (Type_quoted)
			from until full loop
				extend (create {like item}.make (5))
			end
		ensure
			expected_size: count = 4
		end

feature -- Basic operations

	put (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		local
			value_table: like item
		do
			collate (Type_expanded, agent {ZSTRING}.is_double)
			collate (Type_unquoted, agent {ZSTRING}.is_code_identifier)
			collate (Type_quoted, agent requires_quotes)

			across Current as line loop
				value_table := line.item
				if value_table.count > 0 then
					output.put_indent (tab_count)
					across value_table as table loop
						if not table.is_first then
							output.put_string_8 (Semicolon_space)
						end
						output.put_string_8 (table.key)
						output.put_string_8 (Equals_sign)
						if line.cursor_index = Type_quoted then
							output.put_character_8 ('"')
							output.put_string (Pyxis.escaped (table.item, False))
							output.put_character_8 ('"')
						else
							output.put_string (table.item)
						end
					end
					output.put_new_line
				end
				value_table.wipe_out
			end
		ensure
			empty_attribute_lines: across Current as line all line.item.is_empty end
		end

feature {NONE} -- Implementation

	collate (a_type: INTEGER; has_property: FUNCTION [ZSTRING, BOOLEAN])
		local
			source_table: like item
		do
			if attached i_th (a_type) as destination_table then
				across Types_expanded_to_quoted as type loop
					if a_type /= type.item then
						source_table := i_th (type.item)
						across name_query (source_table, has_property) as name loop
							destination_table.extend (source_table [name.item], name.item)
							source_table.remove (name.item)
						end
					end
				end
			end
		end

	name_query (a_table: like item; has_property: FUNCTION [ZSTRING, BOOLEAN]): EL_STRING_8_LIST
		do
			Result := Name_list
			Result.wipe_out
			across a_table as table loop
				if has_property (table.item) then
					Result.extend (table.key)
				end
			end
		end

	requires_quotes (str: ZSTRING): BOOLEAN
		do
			Result := str.has (' ') or else not (str.is_code_identifier or str.is_double)
		end

feature {NONE} -- Constants

	Equals_sign: STRING = " = "

	Name_list: EL_STRING_8_LIST
		once
			create Result.make_empty
		end

	Semicolon_space: STRING = "; "

end