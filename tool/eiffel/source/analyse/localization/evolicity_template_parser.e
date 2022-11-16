note
	description: "Evolicity template parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-16 17:36:39 GMT (Wednesday 16th November 2022)"
	revision: "8"

class
	EVOLICITY_TEMPLATE_PARSER

inherit
	EL_FILE_PARSER
		export
			{NONE} all
			{ANY} source_file_path, find_all
		redefine
			reset, make_default, source_text
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

	ignored_keys: EL_HASH_SET [ZSTRING]

	locale_keys: EL_ZSTRING_LIST

feature -- Element change

	reset
		do
			Precursor
			locale_keys.wipe_out
		end

feature {NONE} -- Patterns

	new_pattern: like all_of
		do
			Result := all_of (<< character_literal ('$'), identifier |to| agent on_identifier >>)
		end

feature {NONE} -- Event handlers

	on_identifier (start_index, end_index: INTEGER)
		local
			name: ZSTRING
		do
			name := source_substring (start_index, end_index, True)
			if not ignored_keys.has (name) then
				locale_keys.extend (Translation_key_template #$ [name])
			end
		end

feature {NONE} -- Internal attributes

	source_text: ZSTRING

feature {NONE} -- Constants

	Translation_key_template: ZSTRING
		once
			Result := "{$%S}"
		end

end