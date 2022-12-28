note
	description: "List of Pyxis attribute lines for output to [$source EL_OUTPUT_MEDIUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-28 18:58:57 GMT (Wednesday 28th December 2022)"
	revision: "1"

class
	EL_PYXIS_ATTRIBUTES

inherit
	FIXED_LIST [HASH_TABLE [ZSTRING, STRING]]
		rename
			make as make_list
		export
			{NONE} all
			{ANY} first, last, i_th
		end

	EL_MODULE_PYXIS

create
	make

feature -- Basic operations

	write_to (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		local
			value_table: like item; use_quotes: BOOLEAN
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
						use_quotes := line.is_last and then not table.item.is_code_identifier
						if use_quotes then
							output.put_character_8 ('"')
						end
						output.put_string (table.item)
						if use_quotes then
							output.put_character_8 ('"')
						end
					end
					output.put_new_line
				end
				value_table.wipe_out
			end
		ensure
			empty_attribute_lines: across Current as line all line.item.is_empty end
		end

feature {NONE} -- Initialization

	make
		do
			make_list (Pyxis.Type_represented)
			from until full loop
				extend (create {like item}.make (5))
			end
		ensure
			expected_size: count = 3
		end

feature {NONE} -- Constants

	Equals_sign: STRING = " = "

	Semicolon_space: STRING = "; "

end