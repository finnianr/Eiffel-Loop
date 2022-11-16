note
	description: "Evolicity template parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EVOLICITY_TEMPLATE_PARSER

inherit
	EL_FILE_PARSER
		export
			{ANY} source_file_path, find_all
		redefine
			reset, make_default
		end

	EL_EIFFEL_TEXT_PATTERN_FACTORY

create
	make

feature {NONE} -- Initialization

	make (file_path: FILE_PATH)
		do
			make_default
			set_source_text_from_file (file_path)
		end

	make_default
		do
			create locale_keys.make_empty
			create ignored_keys.make (13)
			Precursor
		end

feature -- Access

	locale_keys: EL_ZSTRING_LIST

	ignored_keys: EL_HASH_SET [ZSTRING]

feature -- Element change

	reset
		do
			Precursor
			locale_keys.wipe_out
		end

feature {NONE} -- Patterns

	new_pattern: like all_of
		do
			Result := all_of (<< character_literal ('$'), c_identifier |to| agent on_identifier >>)
		end

feature {NONE} -- Event handlers

	on_identifier (matched: EL_STRING_VIEW)
		local
			name: ZSTRING
		do
			name := matched.to_string
			if not ignored_keys.has (name) then
				locale_keys.extend (Translation_key_template #$ [name])
			end
		end

feature {NONE} -- Constants

	Translation_key_template: ZSTRING
		once
			Result := "{$%S}"
		end

end