﻿note
	description: "[
		Decode internal Thunderbird subject lines
		Example:
			"=?ISO-8859-15?Q?=DCber_My_Ching?=" -> "Über My Ching"
		
			"=?UTF-8?B?w5xiZXLigqwgTXkgQ2hpbmc=?=" -> Über€ My Ching
			
			"=?UTF-8?Q?3.Journaleintr=c3=a4ge_bearbeiten?=" -> "Journaleinträge bearbeiten"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-12 8:34:43 GMT (Monday 12th May 2025)"
	revision: "22"

class
	TB_SUBJECT_LINE_DECODER

inherit
	EL_ENCODEABLE_AS_TEXT
		rename
			make as make_encoding,
			make_default as make
		end

	EL_MODULE_BASE_64; EL_MODULE_TUPLE

	EL_SHARED_ZSTRING_BUFFER_POOL

create
	make

feature -- Access

	decoded (line: STRING): ZSTRING
		local
			parts: EL_STRING_8_LIST; latin_str: STRING
		do
			if line.starts_with (Marker.begin) and then line.ends_with (Marker.end_) then
				create parts.make_split (line.substring (3, line.count - 2), '?')

				set_encoding_from_name (parts.first_or_empty)
				inspect parts.i_th (2) [1]
					when 'Q' then
						-- Eg: =?ISO-8859-15?Q?=DCber_My_Ching?=
						latin_str := unescaped (parts.last)
					when 'B' then
						-- Eg: =?UTF-8?B?w5xiZXLigqwgTXkgQ2hpbmc=?=
						latin_str := Base_64.decoded (parts.last)
				else
					latin_str := unescaped (parts.last_or_empty)
				end
			else
				set_latin_encoding (1)
				latin_str := line
			end
			if attached String_pool.borrowed_item as borrowed then
				Result := borrowed.empty
				Result.append_encoded (latin_str, encoding)
				Result := Result.twin
				borrowed.return
			end
		end

feature {NONE} -- Implementation

	unescaped (str: STRING): STRING
		local
			hex: EL_HEXADECIMAL_CONVERTER
		do
			create Result.make_empty
			from until str.is_empty loop
				inspect str [1]
					when '=' then
						Result.append_code (hex.substring_to_natural_32 (str, 2, 3))
						str.remove_head (3)
					when '_' then
						Result.append_character (' ')
						str.remove_head (1)
				else
					Result.append_character (str.item (1).to_character_8)
					str.remove_head (1)
				end
			end
		end

feature {NONE} -- Constants

	Marker: TUPLE [begin, end_: STRING]
		once
			create Result
			Tuple.fill (Result, "=?, ?=")
		end

end