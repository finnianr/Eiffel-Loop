note
	description: "Base class for ${EL_ENCODEABLE_AS_TEXT} and ${EL_ENCODING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 12:22:13 GMT (Monday 21st April 2025)"
	revision: "30"

deferred class
	EL_ENCODING_BASE

inherit
	ANY

	EL_ENCODING_TYPE
		rename
			Other as Other_class,
			Latin as Latin_class,
			Utf as Utf_class,
			Windows as Windows_class
		export
			{NONE} all
			{ANY} Other_class, valid_encoding, valid_windows, valid_utf, valid_latin
		end

	EL_SHARED_ENCODING_TABLE

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

	encoding_other: detachable ENCODING note option: transient attribute end
		-- encoding not covered by Latin, UTF or Windows

	id: NATURAL
		-- A 12-bit code suffix that qualifies the `type'
		-- For `Utf' these are: {8, 16, 32}
		-- For `Latin' these are: 1..15
		-- For `Windows' these are: 1250..1258
		do
			Result := encoding & ID_mask
		end

	name: STRING
			--
		do
			if encoding = Other_class then
				if attached encoding_other as l_encoding then
					Result := canonical_name (l_encoding)
				else
					Result := Name_unknown
				end
			else
				create Result.make (12)
				across Class_table as table until Result.count > 0 loop
					if table.item = type then
						Result.append (table.key)
					end
				end
				if Result.count > 0 then
					if type = Latin_class then
						Result.append_character ('-')
						Result.append_integer (8859)
					end
					Result.append_character ('-')
					Result.append_natural_32 (id)
				else
					Result.append (Name_unknown)
				end
			end
		end

	type: NATURAL
		-- a 4-bit code left-shifted by 12 representing the encoding type: UTF, WINDOWS or ISO-8859
		do
			Result := encoding & Class_mask
		end

feature -- Status query

	encoded_as_latin (a_id: NATURAL): BOOLEAN
		require
			valid_id: valid_latin (a_id)
		do
			Result := encoding = Latin_class | a_id
		end

	encoded_as_utf (a_id: NATURAL): BOOLEAN
		require
			valid_id: valid_utf (a_id)
		do
			Result := encoding = Utf_class | a_id
		end

	encoded_as_windows (a_id: NATURAL): BOOLEAN
		require
			valid_id: valid_windows (a_id)
		do
			Result := encoding = Windows_class | a_id
		end

	is_latin_encoded: BOOLEAN
		do
			Result := type = Latin_class
		end

	is_other_encoded: BOOLEAN
		do
			Result := type = Other_class
		end

	is_utf_encoded: BOOLEAN
		do
			Result := type = Utf_class
		end

	is_windows_encoded: BOOLEAN
		do
			Result := type = Windows_class
		end

	same_as (other: EL_ENCODING_BASE): BOOLEAN
		do
			Result := encoding = other.encoding
			if Result and then encoding = Other_class then
				if attached encoding_other as l_encoding
					and then attached other.encoding_other as l_other
				then
					Result := l_encoding ~ l_other
				end
			end
		end

feature -- Element change

	set_default
		do
			set_utf (8)
		end

	set_encoding (a_encoding: NATURAL)
			--
		require
			valid_encoding: a_encoding /= Other_class implies valid_encoding (a_encoding)
		do
			encoding := a_encoding
			if a_encoding /= Other_class then
				encoding_other := Void
			end
		end

	set_encoding_other (a_encoding: ENCODING)
		do
			set_from_name (canonical_name (a_encoding))
		end

	set_from_name (a_name: READABLE_STRING_GENERAL)
			--
		local
			l_encoding: NATURAL
		do
			l_encoding := name_to_encoding (a_name)
			if l_encoding = Other_class then
				encoding := l_encoding
				encoding_other := Encoding_table.item (a_name.as_string_8)

			elseif valid_encoding (l_encoding) then
				set_encoding (l_encoding)
			else
				encoding := 0
			end
		ensure
			reversible: encoding > 0 implies same_as_name (a_name)
		end

	set_from_other (other: EL_ENCODING_BASE)
		do
			set_encoding (other.encoding)
			encoding_other := other.encoding_other
		ensure
			same_encoding: encoding = other.encoding
		end

	set_latin, set_iso_8859 (a_id: NATURAL)
		require
			valid_latin (a_id)
		do
			set_encoding (Latin_class | a_id)
		end

	set_mixed_utf_8_latin_1
		do
			set_encoding (Mixed_utf_8_latin_1)
		end

	set_utf (a_id: NATURAL)
		require
			valid_utf (a_id)
		do
			set_encoding (Utf_class | a_id)
		end

	set_windows (a_id: NATURAL)
		require
			valid_windows (a_id)
		do
			set_encoding (Windows_class | a_id)
		end

feature -- Conversion

	as_encoding: ENCODING
		-- convert to ISE encoding type
		do
			create Result.make (name)
		end

	name_to_encoding (a_name: READABLE_STRING_GENERAL): NATURAL
		local
			hypen_split: EL_SPLIT_ON_CHARACTER_8 [STRING]
			part: STRING; l_type, l_id: NATURAL; mismatch: BOOLEAN
		do
			create hypen_split.make (a_name.to_string_8, '-')
			across hypen_split as split until mismatch loop
				part := split.item; part.to_upper
				inspect split.cursor_index
					when 1 then
						if Class_table.has_key (part) then
							l_type := Class_table.found_item
						else
							mismatch := True
						end
					when 2 then
						if l_type = Latin_class then
							mismatch := part.to_integer /= 8859
						else
							l_id := part.to_natural
						end
					when 3 then
						l_id := part.to_natural
				else
				end
			end
			if mismatch then
				Result := Other_class
			else
				Result := l_type | l_id
			end
		end

feature -- Contract Support

	same_as_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		local
			sg: EL_STRING_GENERAL_ROUTINES
		do
			Result := sg.super_8 (name).same_caseless (a_name.to_string_8)
		end

	valid_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if valid Windows, UTF or Latin encoding name
		do
			Result := a_name.count > 0 and then valid_encoding (name_to_encoding (a_name))
		end

feature {NONE} -- Implementation

	canonical_name (a_encoding: ENCODING): STRING
		-- prepend "cp" to Windows code page numbers
		do
			if attached a_encoding.code_page as code then
				if code.is_natural then
					Result := Prefix_cp + code
				else
					Result := code
				end
			end
		end

feature {NONE} -- Strings

	Name_iso: STRING = "ISO"

	Name_unknown: STRING = "Unknown"

	Name_utf: STRING = "UTF"

	Name_windows: STRING = "WINDOWS"

feature {NONE} -- Constants

	Class_table: EL_STRING_8_TABLE [NATURAL]
		-- `EL_STRING_8_TABLE' needed in case key is of type "EL_STRING_8"
		once
			create Result.make_assignments (<<
				[Name_iso, Latin_class],
				[Name_windows, Windows_class],
				[Name_utf, Utf_class]
			>>)
		end

end