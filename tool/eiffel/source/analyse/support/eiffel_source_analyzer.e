note
	description: "[
		Analyze Eiffel source file for number of identifiers, keywords, quoted strings, quoted characters
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-14 10:24:07 GMT (Thursday 14th September 2023)"
	revision: "1"

class
	EIFFEL_SOURCE_ANALYZER

inherit
	EIFFEL_SOURCE_READER

create
	make

feature {NONE} -- Events

	on_comment (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

	on_manifest_string (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

	on_numeric_constant (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

	on_quoted_string (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

	on_quoted_character (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

	on_word (area: SPECIAL [CHARACTER]; i, count: INTEGER)
		do
		end

end