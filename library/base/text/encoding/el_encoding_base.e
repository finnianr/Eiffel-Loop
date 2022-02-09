note
	description: "Base class for [$source EL_ENCODEABLE_AS_TEXT] and [$source EL_ENCODING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-09 11:37:47 GMT (Wednesday 9th February 2022)"
	revision: "15"

deferred class
	EL_ENCODING_BASE

inherit
	EL_ENCODING_CONSTANTS
		export
			{ANY} valid_encoding, valid_windows, valid_latin, valid_utf
		end

feature {NONE} -- Initialization

	make (a_encoding: NATURAL)
		require
			valid_encoding: valid_encoding (a_encoding)
		do
			make_default
			encoding := a_encoding
		end

	make_default
		-- make UTF-8
		do
			set_default
		end

feature -- Access

	encoding: NATURAL
		-- bitwise OR of `type' and `id'

	id: NATURAL
		-- A 12-bit code suffix that qualifies the `type'
		-- For `Utf' these are: {8, 16, 32}
		-- For `Latin' these are: 1..15
		-- For `Windows' these are: 1250..1258
		do
			Result := encoding & Encoding_id_mask
		end

	name: STRING
			--
		do
			create Result.make (12)
			across Type_code_table as table until Result.count > 0 loop
				if table.item = type then
					Result.append (table.key)
				end
			end
			if Result.count > 0 then
				if type = Latin then
					Result.append_character ('-')
					Result.append_integer (8859)
				end
				Result.append_character ('-')
				Result.append_natural_32 (id)
			else
				Result.append ("Unknown")
			end
		end

	type: NATURAL
		-- a 4-bit code left-shifted by 12 representing the encoding type: UTF, WINDOWS or ISO-8859
		do
			Result := encoding & Encoding_type_mask
		end

feature -- Status query

	encoded_as_latin (a_id: NATURAL): BOOLEAN
		require
			valid_id: valid_latin (a_id)
		do
			Result := encoding = Latin | a_id
		end

	encoded_as_utf (a_id: NATURAL): BOOLEAN
		require
			valid_id: valid_utf (a_id)
		do
			Result := encoding = Utf | a_id
		end

	encoded_as_windows (a_id: NATURAL): BOOLEAN
		require
			valid_id: valid_windows (a_id)
		do
			Result := encoding = Windows | a_id
		end

	is_latin_encoded: BOOLEAN
		do
			Result := type = Latin
		end

	is_utf_encoded: BOOLEAN
		do
			Result := type = Utf
		end

	is_windows_encoded: BOOLEAN
		do
			Result := type = Windows
		end

	same_as (other: EL_ENCODING_BASE): BOOLEAN
		do
			Result := encoding = other.encoding
		end

feature -- Element change

	set_default
		do
			set_utf (8)
		end

	set_encoding (a_encoding: NATURAL)
			--
		require
			valid_encoding: valid_encoding (a_encoding)
		do
			encoding := a_encoding
		end

	set_from_name (a_name: READABLE_STRING_GENERAL)
			--
		local
			l_encoding: NATURAL
		do
			l_encoding := name_to_encoding (a_name)
			if valid_encoding (l_encoding) then
				set_encoding (l_encoding)
			else
				encoding := 0
			end
		ensure
			reversible: encoding > 0 implies a_name.as_upper.same_string (name)
		end

	set_from_other (other: EL_ENCODING_BASE)
		do
			set_encoding (other.encoding)
		ensure
			same_encoding: encoding = other.encoding
		end

	set_latin, set_iso_8859 (a_id: NATURAL)
		require
			valid_latin (a_id)
		do
			set_encoding (Latin | a_id)
		end

	set_utf (a_id: NATURAL)
		require
			valid_utf (a_id)
		do
			set_encoding (Utf | a_id)
		end

	set_windows (a_id: NATURAL)
		require
			valid_windows (a_id)
		do
			set_encoding (Windows | a_id)
		end

feature -- Conversion

	as_encoding: ENCODING
		-- convert to ISE encoding type
		do
			create Result.make (name)
		end

	name_to_encoding (a_name: READABLE_STRING_GENERAL): NATURAL
		local
			hypen_split: EL_SPLIT_ON_CHARACTER [STRING]
			part: STRING; l_type, l_id: NATURAL; mismatch: BOOLEAN
		do
			create hypen_split.make (a_name.to_string_8, '-')
			across hypen_split as split until mismatch loop
				part := split.item; part.to_upper
				inspect split.cursor_index
					when 1 then
						if Type_code_table.has_key (part) then
							l_type := Type_code_table.found_item
						else
							mismatch := True
						end
					when 2 then
						if l_type = Latin then
							mismatch := part.to_integer /= 8859
						else
							l_id := part.to_natural
						end
					when 3 then
						l_id := part.to_natural
				else
				end
			end
			if not mismatch then
				Result := l_type | l_id
			end
		end

feature -- Contract Support

	valid_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := valid_encoding (name_to_encoding (a_name))
		end

feature {NONE} -- Strings

	Name_iso: STRING = "ISO"

	Name_utf: STRING = "UTF"

	Name_windows: STRING = "WINDOWS"

feature {NONE} -- Constants

	Type_code_table: EL_STRING_8_TABLE [NATURAL]
		-- `EL_STRING_8_TABLE' needed in case key is of type "EL_STRING_8"
		once
			create Result.make (<<
				[Name_iso, Latin],
				[Name_windows, Windows],
				[Name_utf, Utf]
			>>)
		end
end