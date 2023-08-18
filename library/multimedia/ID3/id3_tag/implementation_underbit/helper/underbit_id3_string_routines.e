note
	description: "Underbit id3 string routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-18 8:02:22 GMT (Friday 18th August 2023)"
	revision: "5"

deferred class
	UNDERBIT_ID3_STRING_ROUTINES

inherit
	ID3_SHARED_ENCODING_ENUM

	UNDERBIT_ID3_STRING_C_API

	EL_MODULE_REUSEABLE

	STRING_HANDLER

feature {NONE} -- Implementation

	encoding: NATURAL_8
		deferred
		end

	as_zstring (string_ptr: POINTER): ZSTRING
		do
			if encoding = Encoding_enum.iso_8859_1 then
				Result := from_latin_1 (string_ptr)

			elseif encoding = Encoding_enum.UTF_8 then
				Result := from_utf_8 (string_ptr)

			elseif Encoding_enum.is_utf_16 (encoding) then
				Result := from_utf_16 (string_ptr)

			else
				Result := "<Unknown encoding>"
			end
		end

	from_latin_1 (latin_1_ptr: POINTER): ZSTRING
		do
			create Result.make_from_latin_1_c (latin_1_ptr)
		end

	from_ucs_4 (ucs4_ptr: POINTER): EL_C_STRING_32
		do
			create Result.make_shared_of_size (ucs4_ptr, c_ucs_4_length (ucs4_ptr))
		end

	from_utf_16 (utf_16_ptr: POINTER): ZSTRING
		-- Equivalent function to:

		-- 	id3_ucs4_t *id3_utf16_ucs4duplicate(id3_utf16_t const *utf16) {
		--			id3_ucs4_t *ucs4;

		--			ucs4 = malloc((id3_utf16_length(utf16) + 1) * sizeof(*ucs4));
		--			if (ucs4)
		--			id3_utf16_decode(utf16, ucs4);

		--			return release(ucs4);
		-- 	}
		do
			Result := new_string (utf_16_ptr, c_utf_16_length (utf_16_ptr), agent c_id3_utf_16_decode)
		end

	from_utf_8 (utf_8_ptr: POINTER): ZSTRING
		-- Equivalent function to:

		--		id3_ucs4_t *id3_utf8_ucs4duplicate(id3_utf8_t const *utf8){
		--			id3_ucs4_t *ucs4;
		--			ucs4 = malloc((id3_utf8_length(utf8) + 1) * sizeof(*ucs4));
		--			if (ucs4)
		--				id3_utf8_decode(utf8, ucs4);
		--			return release(ucs4);
		--		}
		do
			Result := new_string (utf_8_ptr, c_utf_8_length (utf_8_ptr), agent c_id3_utf_8_decode)
		end

feature {NONE} -- Implementation

	new_string (utf_x_ptr: POINTER; count: INTEGER; decode: PROCEDURE [POINTER, POINTER]): ZSTRING
		do
			across Reuseable.string_32 as reuse loop
				if attached reuse.item as buffer_32 then
					buffer_32.resize (count)
					decode (utf_x_ptr, buffer_32.area.base_address)
					buffer_32.set_count (count)
					Result := buffer_32
				end
			end
		end

end