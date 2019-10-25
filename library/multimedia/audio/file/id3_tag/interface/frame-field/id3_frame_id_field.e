note
	description: "Id3 frame id field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-09 9:45:42 GMT (Wednesday   9th   October   2019)"
	revision: "1"

deferred class
	ID3_FRAME_ID_FIELD

inherit
	ID3_FRAME_FIELD

feature -- Access

	id: STRING
			--
		deferred
		end

	type: NATURAL_8
		do
			Result := Field_type.frame_id
		end

feature -- Element change

	set_id (a_id: like id)
			--
		deferred
		ensure
			is_set: id = a_id
		end
end
