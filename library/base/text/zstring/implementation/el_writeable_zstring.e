note
	description: "Writing contents of [$source ZSTRING] to external strings/objects"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_WRITEABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

	EL_SHARED_UTF_8_ZCODEC

feature -- Write to other

	write_latin (writeable: EL_WRITEABLE)
		-- write `area' sequence as raw characters to `writeable'
		local
			i, l_count: INTEGER; l_area: like area
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				writeable.write_raw_character_8 (l_area [i])
				i := i + 1
			end
		end

feature -- Append to other

	append_to (other: EL_ZSTRING)
		do
			other.append (current_readable)
		end

	append_to_general (other: STRING_GENERAL)
		do
			if attached {EL_ZSTRING} other as str_z then
				append_to (str_z)

			elseif attached {STRING_32} other as str_32 then
				append_to_string_32 (str_32)

			elseif attached {STRING_8} other as str_8 then
				append_to_string_8 (str_8)
			end
		end

	append_to_string_32 (other: STRING_32)
		local
			old_count: INTEGER; area_out: SPECIAL [CHARACTER_32]
		do
			old_count := other.count
			other.grow (old_count + count)
			area_out := other.area

			Codec.decode (count, area, area_out, old_count)
			write_unencoded (area_out, old_count)

			area_out [old_count + count] := '%U'
			other.set_count (old_count + count)
		end

	append_to_string_8 (other: STRING_8)
		local
			str_32: STRING_32; l_buffer: EL_STRING_32_BUFFER_ROUTINES
		do
			str_32 := l_buffer.empty
			append_to_string_32 (str_32)
			other.append_string_general (str_32)
		end

	append_to_utf_8 (utf_8_out: STRING_8)
		do
			Utf_8_Codec.append_general_to_utf_8 (current_readable, utf_8_out)
		end

end