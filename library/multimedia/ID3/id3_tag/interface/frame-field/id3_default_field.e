note
	description: "Id3 default field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-10 12:11:34 GMT (Thursday 10th October 2019)"
	revision: "1"

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
