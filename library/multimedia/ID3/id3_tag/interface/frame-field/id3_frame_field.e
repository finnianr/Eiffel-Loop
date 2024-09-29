note
	description: "Id3 frame field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-28 7:56:43 GMT (Saturday 28th September 2024)"
	revision: "8"

deferred class
	ID3_FRAME_FIELD

inherit
	ID3_SHARED_FRAME_FIELD_TYPES

feature -- Access

	type: NATURAL_8
			--
		deferred
		ensure
			valid_type: Field_type.valid_value (type)
		end

	type_name: STRING
		do
			Result := Field_type.name (type)
		end

end