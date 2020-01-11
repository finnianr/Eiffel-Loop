note
	description: "Base class for [$source EL_ENCODEABLE_AS_TEXT] and [$source EL_ENCODING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 11:48:49 GMT (Saturday 11th January 2020)"
	revision: "5"

class
	EL_ENCODING_BASE

feature {NONE} -- Initialization

	make_default, make_utf_8
		do
			encoding_bitmap := Type_utf | 8
		end

	make_latin_1
		do
			make_bitmap (Type_latin | 1)
		end

	make_bitmap (a_encoding_bitmap: INTEGER)
		do
			make_default
			encoding_bitmap := a_encoding_bitmap
		end

feature -- Access

	id: INTEGER
		-- A 12-bit code suffix that qualifies the `type'
		-- For `Type_utf' these are: {8, 16, 32}
		-- For `Type_latin' these are: 1..15
		-- For `Type_windows' these are: 1250..1258
		do
			Result := encoding_bitmap & Type_mask
		end

	encoding_bitmap: INTEGER
		-- bitwise OR of `type' and `id'

	name: STRING
			--
		do
			create Result.make (12)
			if encoding_bitmap = 0 then
				Result.append (once "Unknown")
			else
				inspect type
					when Type_utf then
						Result.append (Name_utf)
					when Type_windows then
						Result.append (Name_windows)
					when Type_latin then
						Result.append (Name_iso)
						Result.append_character ('-')
						Result.append_integer (8859)
				else
				end
				Result.append_character ('-')
				Result.append_integer (id)
			end
		end

	type: INTEGER
		-- a 4-bit code left-shifted by 12 representing the encoding type: UTF, WINDOWS or ISO-8859
		do
			Result := encoding_bitmap & ID_mask
		end

feature -- Status query

	is_valid (a_type, a_id: INTEGER): BOOLEAN
		do
			Result := Valid_types.has (a_type) and then Valid_id_sets.item (a_type).has (a_id)
		end

feature -- Status query

	is_latin_id (a_id: INTEGER): BOOLEAN
		require
			valid_id: is_valid (Type_latin, a_id)
		do
			Result := encoding_bitmap = Type_latin | a_id
		end

	is_type_latin: BOOLEAN
		do
			Result := type = Type_latin
		end

	is_type_utf: BOOLEAN
		do
			Result := type = Type_utf
		end

	is_type_windows: BOOLEAN
		do
			Result := type = Type_windows
		end

	is_utf_id (a_id: INTEGER): BOOLEAN
		require
			valid_id: is_valid (Type_utf, a_id)
		do
			Result := encoding_bitmap = Type_utf | a_id
		end

	is_windows_id (a_id: INTEGER): BOOLEAN
		require
			valid_id: is_valid (Type_windows, a_id)
		do
			Result := encoding_bitmap = Type_windows | a_id
		end

	same_as (other: EL_ENCODING_BASE): BOOLEAN
		do
			Result := encoding_bitmap = other.encoding_bitmap
		end

feature -- Element change

	set_encoding (a_type, a_id: INTEGER)
			--
		require
			valid_type_and_id: is_valid (a_type, a_id)
		do
			encoding_bitmap := a_type | a_id
		ensure
			type_set: type = a_type
			id_set: id = a_id
		end

	set_from_name (a_name: READABLE_STRING_GENERAL)
			--
		local
			parts: EL_SPLIT_STRING_LIST [STRING]
			part: STRING; l_type, l_id: INTEGER
		do
			create parts.make (a_name.to_string_8, once "-")
			from parts.start until parts.after loop
				part := parts.item
				if parts.index = 1 then
					part.to_upper
					if part ~ Name_iso then
						parts.forth
						if not parts.after and then parts.item.to_integer = 8859 then
							l_type := Type_latin
						end
					elseif part ~ Name_windows then
						l_type := Type_windows
					elseif part ~ Name_utf then
						l_type := Type_utf
					end
				else
					l_id := parts.item.to_integer
				end
				parts.forth
			end
			if is_valid (l_type, l_id) then
				set_encoding (l_type, l_id)
			else
				encoding_bitmap := 0
			end
		ensure
			reversible: encoding_bitmap > 0 implies a_name.to_string_8.as_upper ~ name
		end

	set_from_other (other: EL_ENCODING_BASE)
		do
			set_encoding (other.type, other.id)
		ensure
			same_encoding: encoding_bitmap = other.encoding_bitmap
		end

	set_default
		do
			set_utf (8)
		end

	set_latin, set_iso_8859 (a_id: INTEGER)
		do
			set_encoding (Type_latin, a_id)
		end

	set_utf (a_id: INTEGER)
		do
			set_encoding (Type_utf, a_id)
		end

	set_windows (a_id: INTEGER)
		do
			set_encoding (Type_windows, a_id)
		end

feature -- Encoding types

	Type_latin: INTEGER = 0x1000

	Type_utf: INTEGER = 0x3000

	Type_windows: INTEGER = 0x2000

	Valid_types: ARRAY [INTEGER]
		once
			Result := Valid_id_sets.current_keys
		end

feature {NONE} -- Strings

	Name_iso: STRING = "ISO"

	Name_utf: STRING = "UTF"

	Name_windows: STRING = "WINDOWS"

feature {NONE} -- Constants

	ID_mask: INTEGER = 0xF000
		-- masks out the `id' from `encoding_bitmap'

	Type_mask: INTEGER = 0xFFF
		-- masks out the `type' from `encoding_bitmap'

	Valid_id_sets: HASH_TABLE [SET [INTEGER], INTEGER]
		local
			utf_encodings: ARRAYED_SET [INTEGER]
		once
			create Result.make_equal (3)
			create utf_encodings.make (3)
			across << 8, 16, 32 >> as bytes loop utf_encodings.put (bytes.item) end
			Result [Type_utf] := utf_encodings

			Result [Type_latin] := 1 |..| 15
			Result [Type_windows] := 1250 |..| 1258
		end

end
