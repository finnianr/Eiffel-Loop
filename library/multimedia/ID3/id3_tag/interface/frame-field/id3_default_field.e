note
	description: "Id3 default field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	ID3_DEFAULT_FIELD

inherit
	ANY
	
	ID3_FRAME_FIELD

feature -- Access

	type: NATURAL_8
		do
			Result := Field_type.default
		end
end