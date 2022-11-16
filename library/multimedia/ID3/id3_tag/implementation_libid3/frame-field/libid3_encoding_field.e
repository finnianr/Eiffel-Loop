note
	description: "Libid3 encoding field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	LIBID3_ENCODING_FIELD

inherit
	ID3_ENCODING_FIELD

	LIBID3_INTEGER_FIELD
		rename
			integer as libid3_encoding,
			set_integer as set_libid3_encoding
		undefine
			type
		redefine
			Libid3_types
		end

	ID3_SHARED_ENCODING_ENUM

create
    make

feature -- Access

	encoding: NATURAL_8
			--
		do
			Result := Encoding_enum.from_libid3 (libid3_encoding)
		end

feature -- Element change

	set_encoding (a_encoding: NATURAL_8)
		do
			set_libid3_encoding (Encoding_enum.to_libid3 (a_encoding))
		end

feature -- Status query

	is_encoding: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Constant

	Libid3_types: ARRAY [INTEGER]
		once
			Result := << FN_text_encoding >>
		end
end