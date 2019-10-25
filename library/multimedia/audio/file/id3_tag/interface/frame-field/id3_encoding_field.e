note
	description: "Id3 encoding field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-10 14:11:43 GMT (Thursday   10th   October   2019)"
	revision: "1"

deferred class
	ID3_ENCODING_FIELD

inherit
	ID3_FRAME_FIELD

	ID3_SHARED_ENCODING_ENUM

feature -- Access

	encoding: NATURAL_8
		deferred
		end

	name: STRING
		do
			Result := Encoding_enum.name (encoding)
		end

	type: NATURAL_8
		do
			Result := Field_type.encoding
		end

feature -- Element change

	set_encoding (a_encoding: NATURAL_8)
		deferred
		end
end
