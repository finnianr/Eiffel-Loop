note
	description: "[
		Translation table that stores all translation item text and lookup keys as a single
		shared UTF-8 encoded string of type ${IMMUTABLE_STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-27 13:06:11 GMT (Tuesday 27th August 2024)"
	revision: "2"

class
	EL_IMMUTABLE_TRANSLATION_TABLE

inherit
	EL_IMMUTABLE_UTF_8_TABLE

create
	make_from_table

feature {NONE} -- Initialization

	make_from_table (a_language: STRING; table: EL_MULTI_LANGUAGE_TRANSLATION_TABLE)
		require
			has_translation: table.language_set.has (a_language)
		do
			language := a_language
			make_utf_8 (Table_format.Indented, table.as_utf_8_manifest_for (a_language))
		end

feature -- Access

	language: STRING

end