note
	description: "Encoding constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-10 8:10:52 GMT (Thursday 10th February 2022)"
	revision: "6"

deferred class
	EL_ENCODING_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Contract Support

	valid_encoding (encoding: NATURAL): BOOLEAN
		do
			inspect encoding & Encoding_type_mask
				when Utf then
					Result := valid_utf (encoding & Encoding_id_mask)
				when Latin then
					Result := valid_latin (encoding & Encoding_id_mask)
				when Windows then
					Result := valid_windows (encoding & Encoding_id_mask)
				when Other then
					Result := encoding = Other
			else
			end
		end

	frozen valid_latin (id: NATURAL): BOOLEAN
		do
			-- ISO 8859-12 was originally proposed to support the Celtic languages.[1] ISO 8859-12 was later
			-- slated for Latin/Devanagari, but this was abandoned in 1997
			inspect id
				when 1 .. 11, 13 .. 15 then
					Result := True
			else
			end
		end

	frozen valid_utf (id: NATURAL): BOOLEAN
		do
			inspect id
				when 8, 16, 32 then
					Result := True
			else
			end
		end

	frozen valid_windows (id: NATURAL): BOOLEAN
		do
			inspect id
				when 1250 .. 1258 then
					Result := True
			else
			end
		end

feature {STRING_HANDLER} -- Encoding classes

	Latin: NATURAL = 0x1000

	Other: NATURAL = 0x4000

	Utf: NATURAL = 0x3000

	Windows: NATURAL = 0x2000

feature {STRING_HANDLER} -- Common encodings

	Latin_1: NATURAL = 0x1001

	Utf_8: NATURAL = 0x3008

	Utf_16: NATURAL = 0x3010

feature {NONE} -- Constants

	Encoding_id_mask: NATURAL = 0xFFF

	Encoding_type_mask: NATURAL = 0xF000

end