note
	description: "Object that encodes text using an encoding specified by `encoding' field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-27 9:00:47 GMT (Tuesday 27th February 2018)"
	revision: "4"

class
	EL_ENCODEABLE_AS_TEXT

create
	make_default, make_utf_8, make_latin_1

feature {NONE} -- Initialization

	make_default
		do
			create encoding_change_actions
			set_default_encoding
		end

	make_latin_1
		do
			create encoding_change_actions
			set_iso_8859_encoding (1)
		end

	make_utf_8
		do
			create encoding_change_actions
			set_utf_encoding (8)
		end

feature -- Access

	encoding_change_actions: ACTION_SEQUENCE

	encoding_id: INTEGER
		-- A 12-bit code suffix that qualifies the `encoding_type'
		-- For `Type_utf' these are: {8, 16, 32}
		-- For `Type_latin' these are: 1..16
		-- For `Type_windows' these are: 1250..1258
		do
			Result := internal_encoding & Type_mask
		end

	encoding_name: STRING
			--
		do
			create Result.make (12)
			if internal_encoding = 0 then
				Result.append (once "Unknown")
			else
				inspect encoding_type
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
				Result.append_integer (encoding_id)
			end
		end

	encoding_type: INTEGER
		-- a 4-bit code left-shifted by 12 representing the encoding type: UTF, WINDOWS or ISO-8859
		do
			Result := internal_encoding & ID_mask
		end

feature -- Status query

	is_latin_encoded: BOOLEAN
		do
			Result := encoding_type = Type_latin
		end

	is_latin_encoding (id: INTEGER): BOOLEAN
		require
			valid_id: is_valid_encoding (Type_latin, id)
		do
			Result := internal_encoding = Type_latin | id
		end

	is_utf_encoded: BOOLEAN
		do
			Result := encoding_type = Type_utf
		end

	is_utf_encoding (id: INTEGER): BOOLEAN
		require
			valid_id: is_valid_encoding (Type_utf, id)
		do
			Result := internal_encoding = Type_utf | id
		end

	is_valid_encoding (type, id: INTEGER): BOOLEAN
		do
			Result := Valid_types.has (type) and then Valid_id_sets.item (type).has (id)
		end

	is_windows_encoded: BOOLEAN
		do
			Result := encoding_type = Type_windows
		end

	is_windows_encoding (id: INTEGER): BOOLEAN
		require
			valid_id: is_valid_encoding (Type_windows, id)
		do
			Result := internal_encoding = Type_windows | id
		end

	same_encoding (other: EL_ENCODEABLE_AS_TEXT): BOOLEAN
		do
			Result := internal_encoding = other.internal_encoding
		end

feature -- Element change

	frozen set_encoding (type, id: INTEGER)
			--
		require
			valid_encoding: is_valid_encoding (type, id)
		local
			changed: BOOLEAN
		do
			changed := internal_encoding /= type | id
			internal_encoding := type | id
			if changed and then not encoding_change_actions.is_empty then
				encoding_change_actions.call ([])
			end
		ensure
			encoding_type_set: encoding_type = type
			encoding_id_set: encoding_id = id
		end

	set_default_encoding
		do
			set_utf_encoding (8)
		end

	set_encoding_from_name (name: READABLE_STRING_GENERAL)
			--
		local
			parts: EL_SPLIT_STRING_LIST [STRING]
			part: STRING; type, id: INTEGER
		do
			create parts.make (name.to_string_8, once "-")
			from parts.start until parts.after loop
				part := parts.item
				if parts.index = 1 then
					part.to_upper
					if part ~ Name_iso then
						parts.forth
						if not parts.after and then parts.item.to_integer = 8859 then
							type := Type_latin
						end
					elseif part ~ Name_windows then
						type := Type_windows
					elseif part ~ Name_utf then
						type := Type_utf
					end
				else
					id := parts.item.to_integer
				end
				parts.forth
			end
			if is_valid_encoding (type, id) then
				set_encoding (type, id)
			else
				internal_encoding := 0
			end
		ensure
			reversible: internal_encoding > 0 implies name.to_string_8.as_upper ~ encoding_name
		end

	set_encoding_from_other (other: EL_ENCODEABLE_AS_TEXT)
		do
			set_encoding (other.encoding_type, other.encoding_id)
		ensure
			same_encoding: internal_encoding = other.internal_encoding
		end

	set_latin_encoding, set_iso_8859_encoding (id: INTEGER)
		do
			set_encoding (Type_latin, id)
		end

	set_utf_encoding (id: INTEGER)
		do
			set_encoding (Type_utf, id)
		end

	set_windows_encoding (id: INTEGER)
		do
			set_encoding (Type_windows, id)
		end

feature {EL_ENCODEABLE_AS_TEXT} -- Internal attributes

	internal_encoding: INTEGER
		-- bitwise OR of `encoding_type' and `encoding_id'

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
		-- masks out the `encoding_id' from `internal_encoding'

	Type_mask: INTEGER = 0xFFF
		-- masks out the `encoding_type' from `internal_encoding'

	Valid_id_sets: HASH_TABLE [SET [INTEGER], INTEGER]
		local
			utf_encodings: ARRAYED_SET [INTEGER]
		once
			create Result.make_equal (3)
			create utf_encodings.make (3)
			across << 8, 16, 32 >> as bytes loop utf_encodings.put (bytes.item) end
			Result [Type_utf] := utf_encodings

			Result [Type_latin] := 1 |..| 16
			Result [Type_windows] := 1250 |..| 1258
		end

end
