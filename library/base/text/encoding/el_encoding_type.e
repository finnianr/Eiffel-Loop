note
	description: "Encoding constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-24 16:08:53 GMT (Sunday 24th December 2023)"
	revision: "10"

deferred class
	EL_ENCODING_TYPE

inherit
	EL_ANY_SHARED

feature -- Contract Support

	frozen valid_encoding (a_encoding: NATURAL): BOOLEAN
		-- `True' if `a_encoding' is valid Windows, UTF or Latin encoding
		do
			inspect a_encoding & Class_mask
				when Utf then
					Result := valid_utf (a_encoding & ID_mask)
				when Latin then
					Result := valid_latin (a_encoding & ID_mask)
				when Windows then
					Result := valid_windows (a_encoding & ID_mask)
			else
			end
		end

	frozen valid_latin (a_id: NATURAL): BOOLEAN
		do
			-- ISO 8859-12 was originally proposed to support the Celtic languages.[1] ISO 8859-12 was later
			-- slated for Latin/Devanagari, but this was abandoned in 1997
			inspect a_id
				when 1 .. 11, 13 .. 15 then
					Result := True
			else
			end
		end

	frozen valid_utf (a_id: NATURAL): BOOLEAN
		do
			inspect a_id
				when 9 then
				-- mixed UTF-8 and Latin-1
					Result := True
				when 8, 16, 32 then
					Result := True
			else
			end
		end

	frozen valid_windows (a_id: NATURAL): BOOLEAN
		do
			inspect a_id
				when 1250 .. 1258 then
					Result := True
			else
			end
		end

feature -- Encoding classes

	Latin: NATURAL = 0x1000

	Other: NATURAL = 0x4000

	Utf: NATURAL = 0x3000

	Windows: NATURAL = 0x2000

feature -- Common encodings

	Latin_1: NATURAL = 0x1001

	Mixed_utf_8_latin_1: NATURAL = 0x3009
		-- mixed UTF-8 and Latin-1

	Utf_16: NATURAL = 0x3010

	Utf_8: NATURAL = 0x3008

feature -- Bit masks

	Class_mask: NATURAL = 0xF000
		-- mask out encoding id leaving only class

	ID_mask: NATURAL = 0xFFF
		-- mask out encoding class leaving only id

end