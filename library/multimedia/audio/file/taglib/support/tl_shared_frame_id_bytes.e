note
	description: "Tl shared frame id bytes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 19:18:33 GMT (Monday 11th November 2019)"
	revision: "1"

deferred class
	TL_SHARED_FRAME_ID_BYTES

inherit
	TL_SHARED_FRAME_ID_ENUM

feature {NONE} -- Implementation

	frame_id_bytes (enum_code: NATURAL_8): TL_BYTE_VECTOR
		do
			Result := Once_frame_id
			Result.set_data (Frame_id.name (enum_code))
		end

	once_frame_id_enum: NATURAL_8
		do
			Result := Frame_id.value (Once_frame_id.to_temporary_string (False))
		end

feature {NONE} -- Constants

	Once_frame_id: TL_BYTE_VECTOR
		once
			create Result.make_empty
		end

end
