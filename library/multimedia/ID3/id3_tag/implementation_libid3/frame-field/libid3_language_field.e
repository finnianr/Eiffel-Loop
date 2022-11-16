note
	description: "Libid3 language field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	LIBID3_LANGUAGE_FIELD

inherit
	ID3_LANGUAGE_FIELD
		select
			string
		end

	LIBID3_LATIN_1_STRING_FIELD
		rename
			string as language
		undefine
			type
		redefine
			Libid3_types
		end

create
	make

feature {NONE} -- Constant

	Libid3_types: ARRAY [INTEGER]
		once
			Result := << FN_language >>
		end
end