note
	description: "Summary description for {EL_ENCODEABLE_AS_TEXT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	EL_ENCODEABLE_AS_TEXT

create
	make_utf_8, make_latin_1

feature {NONE} -- Initialization

	make_utf_8
		do
			set_utf_encoding (8)
		end

	make_latin_1
		do
			set_iso_8859_encoding (1)
		end

feature -- Access

	encoding: INTEGER
		-- if type is UTF: 8, 16, 32
		-- if type is ISO-8859: 1-16

	encoding_type: STRING

	encoding_name: STRING
			--
		do
			if encoding = Encoding_unknown then
				Result := Encoding_unknown_type
			else
				create Result.make_from_string (encoding_type)
				Result.append_character ('-')
				Result.append_integer (encoding)
			end
		end

feature -- Status query

	is_valid_encoding (a_type: like encoding_type; a_encoding: like encoding): BOOLEAN
		do
			Result := Encoding_types.has (a_type.as_upper) and then Valid_encodings.item (a_type).has (a_encoding)
		end

	is_utf8_encoded: BOOLEAN
		do
			Result := encoding_type = Encoding_utf and then encoding = 8
		end

feature -- Element change

	set_encoding_from_other (other: EL_ENCODEABLE_AS_TEXT)
		do
			set_encoding (other.encoding_type, other.encoding)
		end

	set_utf_encoding (a_encoding: like encoding)
		do
			set_encoding (Encoding_utf, a_encoding)
		end

	set_latin_encoding, set_iso_8859_encoding (a_encoding: like encoding)
		do
			set_encoding (Encoding_iso_8859, a_encoding)
		end

	set_windows_encoding (a_encoding: like encoding)
		do
			set_encoding (Encoding_windows, a_encoding)
		end

	set_encoding (a_type: like encoding_type; a_encoding: like encoding)
			--
		require
			valid_encoding: is_valid_encoding (a_type, a_encoding)
		do
			if Valid_encodings.current_keys.has (a_type) then
				encoding_type := a_type
			else
				encoding_type := Encoding_types [a_type.as_upper]
			end
			encoding := a_encoding
		ensure
			encoding_type_set: Valid_encodings.current_keys.has (encoding_type)
		end

	set_encoding_from_name (name: READABLE_STRING_GENERAL)
			--
		local
			parts: LIST [READABLE_STRING_GENERAL]
			l_type: STRING
		do
			parts := name.as_upper.split ('-')
			create l_type.make (parts.first.count)
			l_type.append_string_general (parts.first)
			if parts.count = 3 then
				l_type.append_character ('-')
				l_type.append_string_general (parts.i_th (2))
			end
			set_encoding (l_type.to_string_8, parts.last.to_integer)
		end

feature -- Constants

	Encoding_unknown: INTEGER = 0

	Encoding_ISO_8859: STRING = "ISO-8859"

	Encoding_windows: STRING = "Windows"

	Encoding_UTF: STRING = "UTF"

	Encoding_unknown_type: STRING
		once
			Result := "Unknown"
		end

	Valid_encodings: HASH_TABLE [SET [INTEGER], STRING]
		local
			utf_encodings: ARRAYED_SET [INTEGER]
		once
			create Result.make (3)
			create utf_encodings.make (3)
			across << 8, 16, 32 >> as bytes loop utf_encodings.put (bytes.item)  end
			Result [Encoding_UTF] := utf_encodings

			Result [Encoding_ISO_8859] := 1 |..| 16
			Result [Encoding_windows] := 1250 |..| 1258
		end

	Encoding_types: HASH_TABLE [STRING, STRING]
			-- map upper name to name
		once
			create Result.make_equal (3)
			across Valid_encodings.current_keys as type loop
				Result [type.item.as_upper] := type.item
			end
		end

end

