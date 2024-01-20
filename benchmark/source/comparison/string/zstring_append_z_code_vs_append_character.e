note
	description: "{${ZSTRING}}.append_z_code VS append_character"
	notes: "[
		Passes over 500 millisecs (in descending order)

			append_zcode     :  4297.0 times (100%)
			append_character :  4053.0 times (-5.7%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "10"

class
	ZSTRING_APPEND_Z_CODE_VS_APPEND_CHARACTER

inherit
	STRING_BENCHMARK_COMPARISON

	EL_SHARED_ZSTRING_CODEC

create
	make

feature -- Access

	Description: STRING = "ZSTRING.append_zcode VS append_character"

feature -- Basic operations

	execute
		local
			characters: ARRAYED_LIST [CHARACTER_32]; codes: ARRAYED_LIST [NATURAL]
			str: ZSTRING
		do
			create str.make_empty
			create characters.make (100); create codes.make (100)
			across Hexagram.Name_list as list loop
				across << list.item.pinyin, list.item.hanzi >> as name loop
					across name.item as c loop
						characters.extend (c.item)
						codes.extend (Codec.as_z_code (c.item))
					end
				end
			end
			compare ("compare append character", <<
				["append_zcode", 	agent append_zcode (str, codes)],
				["append_character",	agent append_character (str, characters)]
			>>)
		end

feature {NONE} -- append_character

	append_character (str: ZSTRING; characters: LIST [CHARACTER_32])
		do
			str.wipe_out
			across characters as c loop
				str.append_character (c.item)
			end
		end

	append_zcode (str: ZSTRING; codes: LIST [NATURAL])
		do
			str.wipe_out
			across codes as code loop
				str.append_z_code (code.item)
			end
		end

end