note
	description: "Text patterns for computer language"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 8:17:07 GMT (Monday 14th November 2022)"
	revision: "1"

deferred class
	EL_CODE_LANGUAGE_PATTERN_FACTORY

inherit
	EL_TEXT_PATTERN_FACTORY

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