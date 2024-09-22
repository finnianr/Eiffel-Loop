note
	description: "Text patterns for computer language"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 9:13:33 GMT (Sunday 22nd September 2024)"
	revision: "4"

deferred class
	TP_CODE_LANGUAGE_FACTORY

inherit
	TP_FACTORY
		rename
			quoted_string as basic_quoted_string
		end

feature -- Access

	escape_character: CHARACTER_32
		deferred
		end

	language_name: STRING
		deferred
		end

feature -- String manifest patterns

	escaped_character_sequence: like all_of
		do
			Result := all_of (<< character_literal (escape_character), special_character >>)
		end

	special_character: like one_character_from
		do
			Result := one_character_from (code_key_string)
		end

feature {NONE} -- Implementation

	code_key_string: STRING
		do
			create Result.make_filled ('-', Code_table.count)
			if attached Code_table.key_list.area as area then
				Result.area.copy_data (area, 0, 0, Result.count)
			end
		end

	code_table: EL_HASH_TABLE [INTEGER, CHARACTER]
		deferred
		end

end