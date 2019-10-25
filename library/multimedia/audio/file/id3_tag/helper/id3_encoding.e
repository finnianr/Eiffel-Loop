note
	description: "Id3 encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-10 14:11:43 GMT (Thursday   10th   October   2019)"
	revision: "1"

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
