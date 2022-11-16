note
	description: "Id3 encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	ID3_ENCODING

inherit
	EL_ENUMERATION_VALUE [NATURAL_8]
		rename
			enumeration as Encoding_enum
		redefine
			make_default
		end

	ID3_SHARED_ENCODING_ENUM

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			value := Encoding_enum.unknown
		end
end