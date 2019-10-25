note
	description: "Libid3 language field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-16 18:04:05 GMT (Wednesday   16th   October   2019)"
	revision: "1"

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
