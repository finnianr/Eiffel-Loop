note
	description: "Id3 frame field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-10 12:14:01 GMT (Thursday 10th October 2019)"
	revision: "6"

deferred class
	ID3_FRAME_FIELD

inherit
	ID3_SHARED_FRAME_FIELD_TYPES

feature -- Access

	type: NATURAL_8
			--
		deferred
		ensure
			valid_type: Field_type.is_valid_value (type)
		end

	type_name: STRING
		do
			Result := Field_type.name (type)
		end

end
