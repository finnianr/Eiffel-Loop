note
	description: "List of Pyxis attribute lines for output to ${EL_OUTPUT_MEDIUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "6"

class
	EL_PYXIS_ATTRIBUTES

inherit
	FIXED_LIST [HASH_TABLE [ZSTRING, STRING]]
		rename
			make as make_list,
			put as put_table,
			extend as extend_list
		export
			{NONE} all
			{ANY} first, last
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
				extend_list (create {like item}.make (5))
			end
		ensure
			expected_size: count = 4
		end

feature -- Basic operations

	extend (a_type: INTEGER; name: STRING; value: ZSTRING)
		local
			type: INTEGER
		do
			inspect a_type
				when Type_expanded, Type_unquoted, Type_quoted then
					if value.is_double then
						type := Type_expanded
					elseif value.is_code_identifier then
						type := Type_unquoted
					elseif requires_quotes (value) then
						type := Type_quoted
					else
						type := a_type
					end
			else
				type := a_type
			end
			i_th (type).extend (value, name)
		end

	put (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		local
			value_table: like item
		do
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

	requires_quotes (str: ZSTRING): BOOLEAN
		do
			Result := str.has (' ') or else not (str.is_code_identifier or str.is_double)
		end

feature {NONE} -- Constants

	Equals_sign: STRING = " = "

	Semicolon_space: STRING = "; "

end