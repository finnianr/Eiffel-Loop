note
	description: "Text patterns for computer language"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 7:43:09 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_CODE_LANGUAGE_PATTERN_FACTORY

inherit
	EL_TEXT_PATTERN_FACTORY
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
			create Result.make (Code_table.count)
			Code_table.current_keys.do_all (agent Result.extend)
		end

	code_table: EL_HASH_TABLE [INTEGER, CHARACTER]
		deferred
		end

end