note
	description: "Id3 binary data field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	ID3_BINARY_DATA_FIELD

inherit
	ID3_FRAME_FIELD

feature -- Access

	binary_data: MANAGED_POINTER
			--
		deferred
		end

	type: NATURAL_8
		do
			Result := Field_type.binary_data
		end

feature -- Element change

	set_binary_data (data: MANAGED_POINTER)
			--
		deferred
		ensure
			is_set: data.count > 0 implies data ~ binary_data -- Setting to length 0 does not work on libid3
		end

end