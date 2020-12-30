note
	description: "A `STRING_32' with decoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-30 11:10:10 GMT (Wednesday 30th December 2020)"
	revision: "1"

class
	EL_STRING_32

inherit
	STRING_32

create
	make_empty

feature -- Element change

	set_from_encoded (codec: EL_ZCODEC; encoded: READABLE_STRING_8)
		local
			l_area: SPECIAL [CHARACTER_8]; l_lower: INTEGER
		do
			l_lower := encoded.area_lower
			if l_lower > 0 then
				create l_area.make_empty (encoded.count)
				l_area.copy_data (encoded.area, l_lower, 0, encoded.count)
			else
				l_area := encoded.area
			end
			grow (encoded.count)
			set_count (encoded.count)
			codec.decode (encoded.count, l_area, area, 0)
		end

	set_from_utf_8 (utf_8: READABLE_STRING_8)
		local
			c: EL_UTF_CONVERTER
		do
			wipe_out
			c.utf_8_string_8_into_string_32 (utf_8, Current)
		end

	set_from_string (zstr: EL_READABLE_ZSTRING)
		do
			wipe_out
			zstr.append_to_string_32 (Current)
		end
end