note
	description: "Id3 string field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-15 11:01:44 GMT (Tuesday 15th October 2019)"
	revision: "1"

deferred class
	ID3_STRING_FIELD

inherit
	ID3_ENCODEABLE_FRAME_FIELD

	ID3_SHARED_ENCODING_ENUM

feature -- Access

	string: ZSTRING
			--
		deferred
		end

	type: NATURAL_8
		do
			Result := Field_type.string
		end

feature -- Element change

	set_string (str: like string)
			--
		deferred
		ensure
			is_set: string ~ str
		end

end
