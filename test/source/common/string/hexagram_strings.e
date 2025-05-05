note
	description: "[
		I Ching hexagram names and titles in Chinese and English that can be used for testing
		string processing classes.
		
		The English titles are read from the text file:
		
			$EIFFEL_LOOP/test/data/txt/hexagrams.txt
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 9:03:38 GMT (Monday 5th May 2025)"
	revision: "23"

class
	HEXAGRAM_STRINGS

inherit
	ANY

	EL_MODULE_FILE; EL_MODULE_TUPLE

	SHARED_DATA_DIRECTORIES

feature -- Access

	Hanzi_list: ARRAYED_LIST [READABLE_STRING_GENERAL]
		once
			create Result.make (64)
			across Name_list as name loop
				Result.extend (name.item.hanzi)
			end
		end

	Name_list: EL_ARRAYED_LIST [TUPLE [pinyin, hanzi: IMMUTABLE_STRING_32; number: INTEGER]]
			--
		once
			create Result.make_filled (64, agent new_name)
		end

	English_titles_first: STRING
		once
			Result := File.line_one (Hexagrams_path)
		end

	English_titles: EL_STRING_8_LIST
		local
			txt_file: EL_PLAIN_TEXT_FILE
		once
			create txt_file.make_with_name (Hexagrams_path)
			Result := txt_file.new_latin_1_list
		end

	Hexagram_1_array: ARRAY [READABLE_STRING_GENERAL]
		once
			Result := new_parts_array (1, English_titles_first)
		end

	String_arrays_first: ARRAYED_LIST [ARRAY [READABLE_STRING_GENERAL]]
		once
			create Result.make_from_array (<< Hexagram_1_array >>)
		end

	String_arrays: ARRAYED_LIST [ARRAY [READABLE_STRING_GENERAL]]
		once
			create Result.make (64)
			across english_titles as title loop
				Result.extend (new_parts_array (title.cursor_index, title.item))
			end
		end

feature {NONE} -- Implementation

	new_parts_array (index: INTEGER; title: STRING): ARRAY [READABLE_STRING_GENERAL]
		local
			chinese_name: like Name_list.item
		do
			chinese_name := Name_list [index]
			Result := << "Hex. #" + index.out, chinese_name.pinyin, chinese_name.hanzi, title >>
		end

	new_name (i: INTEGER): like Name_list.item
		local
			names: HEXAGRAM_NAMES
		do
			Result := [names.i_th_pinyin_name (i), names.i_th_hanzi_characters (i), i]
		end

feature -- Constants

	Hexagrams_path: FILE_PATH
		once
			Result := Data_dir.txt + "hexagrams.txt"
		end

end