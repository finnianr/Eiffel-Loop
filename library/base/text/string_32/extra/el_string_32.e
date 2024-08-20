note
	description: "Extended ${STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 12:44:51 GMT (Tuesday 20th August 2024)"
	revision: "12"

class
	EL_STRING_32

inherit
	STRING_32
		export
			{EL_STRING_32_CONSTANTS} String_searcher
			{EL_TYPE_CONVERSION_HANDLER} Ctoi_convertor, Ctor_convertor
		end

	EL_STRING_BIT_COUNTABLE [STRING_32]

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

	set_from_string (zstr: EL_READABLE_ZSTRING)
		do
			wipe_out
			zstr.append_to_string_32 (Current)
		end

	set_from_utf_8 (utf_8_string: READABLE_STRING_8)
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			wipe_out
			utf_8.string_8_into_string_32 (utf_8_string, Current)
		end

feature -- Comparison

	same_strings (a, b: READABLE_STRING_32): BOOLEAN
		-- work around for bug in `{SPECIAL}.same_items' affecting `{IMMUTABLE_STRING_32}.same_string'
		do
			if a.count = b.count then
				Result := same_area_items (a.area, b.area, a.area_lower, b.area_lower, a.count)
			end
		end

feature {NONE} -- Implementation

	same_area_items (a, b: like area; a_offset, b_offset, n: INTEGER): BOOLEAN
			-- Are the `n' characters of `b' from `b_offset' position the same as
			-- the `n' characters of `a' from `a_offset'?
		require
			other_not_void: b /= Void
			source_index_non_negative: b_offset >= 0
			destination_index_non_negative: a_offset >= 0
			n_non_negative: n >= 0
			n_is_small_enough_for_source: b_offset + n <= b.count
			n_is_small_enough_for_destination: a_offset + n <= a.count
		local
			i, j, nb: INTEGER
		do
			if a = b and a_offset = b_offset then
				Result := True
			else
				Result := True
				from
					i := b_offset
					j := a_offset
					nb := b_offset + n
				until
					i = nb
				loop
					if b [i] /= a [j] then
						Result := False
						i := nb - 1
					end
					i := i + 1
					j := j + 1
				end
			end
		ensure
			valid_on_empty_area: (n = 0) implies Result
		end

end