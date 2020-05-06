note
	description: "Base class for [$source EL_ENCODEABLE_AS_TEXT] and [$source EL_ENCODING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-06 9:19:05 GMT (Wednesday 6th May 2020)"
	revision: "9"

class
	EL_ENCODING_BASE

feature {NONE} -- Initialization

	make_bitmap (a_encoding_bitmap: NATURAL)
		do
			make_default
			encoding_bitmap := a_encoding_bitmap
		end

	make_default, make_utf_8
		do
			encoding_bitmap := Type_utf | 8
		end

	make_latin_1
		do
			make_bitmap (Type_latin | 1)
		end

feature -- Access

	id: NATURAL
		-- A 12-bit code suffix that qualifies the `type'
		-- For `Type_utf' these are: {8, 16, 32}
		-- For `Type_latin' these are: 1..15
		-- For `Type_windows' these are: 1250..1258
		do
			Result := encoding_bitmap & Type_mask
		end

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
				Result.append_natural_32 (id)
			end
		end

	type: NATURAL
		-- a 4-bit code left-shifted by 12 representing the encoding type: UTF, WINDOWS or ISO-8859
		do
			Result := encoding_bitmap & ID_mask
		end

feature -- Status query

	encoded_as_latin (a_id: NATURAL): BOOLEAN
		require
			valid_id: is_valid_latin_id (a_id)
		do
			Result := encoding_bitmap = Type_latin | a_id
		end

	encoded_as_utf (a_id: NATURAL): BOOLEAN
		require
			valid_id: is_valid_utf_id (a_id)
		do
			Result := encoding_bitmap = Type_utf | a_id
		end

	encoded_as_windows (a_id: NATURAL): BOOLEAN
		require
			valid_id: is_valid_windows_id (a_id)
		do
			Result := encoding_bitmap = Type_windows | a_id
		end

	is_latin_encoded: BOOLEAN
		do
			Result := type = Type_latin
		end

	is_utf_encoded: BOOLEAN
		do
			Result := type = Type_utf
		end

	is_valid_encoding (a_type, a_id: NATURAL): BOOLEAN
		do
			inspect a_type
				when Type_utf then
					Result := is_valid_utf_id (a_id)
				when Type_latin then
					Result := is_valid_latin_id (a_id)
				when Type_windows then
					Result := is_valid_windows_id (a_id)
			else
			end
		end

	is_valid_latin_id (a_id: NATURAL): BOOLEAN
		do
			inspect a_id
				when 1 .. 11, 13 .. 15 then
					Result := True
			else
			end
		end

	is_valid_encoding_type (a_type: NATURAL): BOOLEAN
		do
			inspect a_type
				when Type_utf, Type_windows, Type_latin then
					Result := True
			else
			end
		end

	is_valid_utf_id (a_id: NATURAL): BOOLEAN
		do
			inspect a_id
				when 8, 16, 32 then
					Result := True
			else
			end
		end

	is_valid_windows_id (a_id: NATURAL): BOOLEAN
		do
			inspect a_id
				when 1250 .. 1258 then
					Result := True
			else
			end
		end

	is_windows_encoded: BOOLEAN
		do
			Result := type = Type_windows
		end

	same_as (other: EL_ENCODING_BASE): BOOLEAN
		do
			Result := encoding_bitmap = other.encoding_bitmap
		end

feature -- Element change

	set_default
		do
			set_utf (8)
		end

	set_encoding (a_type, a_id: NATURAL)
			--
		require
			valid_type_and_id: is_valid_encoding (a_type, a_id)
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
			part: STRING; l_type, l_id: NATURAL
		do
			create parts.make (a_name.to_string_8, once "-")
			from parts.start until parts.after loop
				part := parts.item (False)
				if parts.index = 1 then
					part.to_upper
					if part ~ Name_iso then
						parts.forth
						if not parts.after and then parts.integer_item = 8859 then
							l_type := Type_latin
						end
					elseif part ~ Name_windows then
						l_type := Type_windows
					elseif part ~ Name_utf then
						l_type := Type_utf
					end
				else
					l_id := part.to_natural
				end
				parts.forth
			end
			if is_valid_encoding (l_type, l_id) then
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

	set_latin, set_iso_8859 (a_id: NATURAL)
		do
			set_encoding (Type_latin, a_id)
		end

	set_utf (a_id: NATURAL)
		do
			set_encoding (Type_utf, a_id)
		end

	set_windows (a_id: NATURAL)
		do
			set_encoding (Type_windows, a_id)
		end

feature {EL_ENCODING_BASE} -- Internal attributes

	encoding_bitmap: NATURAL
		-- bitwise OR of `type' and `id'

feature {NONE} -- Encoding types

	Type_latin: NATURAL = 0x1000

	Type_utf: NATURAL = 0x3000

	Type_windows: NATURAL = 0x2000

feature {NONE} -- Strings

	Name_iso: STRING = "ISO"

	Name_utf: STRING = "UTF"

	Name_windows: STRING = "WINDOWS"

feature {NONE} -- Constants

	ID_mask: NATURAL = 0xF000
		-- masks out the `id' from `encoding_bitmap'

	Type_mask: NATURAL = 0xFFF
		-- masks out the `type' from `encoding_bitmap'

end
