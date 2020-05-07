note
	description: "Base class for [$source EL_ENCODEABLE_AS_TEXT] and [$source EL_ENCODING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-07 9:33:03 GMT (Thursday 7th May 2020)"
	revision: "10"

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
			encoding := Utf_8
		end

feature -- Access

	id: NATURAL
		-- A 12-bit code suffix that qualifies the `type'
		-- For `Utf' these are: {8, 16, 32}
		-- For `Latin' these are: 1..15
		-- For `Windows' these are: 1250..1258
		do
			Result := encoding & Encoding_id_mask
		end

	encoding: NATURAL
		-- bitwise OR of `type' and `id'

	name: STRING
			--
		do
			create Result.make (12)
			if encoding = 0 then
				Result.append (once "Unknown")
			else
				inspect type
					when Utf then
						Result.append (Name_utf)
					when Windows then
						Result.append (Name_windows)
					when Latin then
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
							l_type := Latin
						end
					elseif part ~ Name_windows then
						l_type := Windows
					elseif part ~ Name_utf then
						l_type := Utf
					end
				else
					l_id := part.to_natural
				end
				parts.forth
			end
			if valid_encoding (l_type | l_id) then
				set_encoding (l_type | l_id)
			else
				encoding := 0
			end
		ensure
			reversible: encoding > 0 implies a_name.to_string_8.as_upper ~ name
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

feature {NONE} -- Strings

	Name_iso: STRING = "ISO"

	Name_utf: STRING = "UTF"

	Name_windows: STRING = "WINDOWS"

end
