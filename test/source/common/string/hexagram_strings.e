note
	description: "[
		I Ching hexagram names and titles in Chinese and English that can be used for testing
		string processing classes.
		
		The English titles are read from the text file:
		
			$EIFFEL_LOOP/test/data/hexagrams.txt
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-18 12:25:19 GMT (Saturday 18th February 2023)"
	revision: "17"

class
	HEXAGRAM_STRINGS

inherit
	ANY

	EL_MODULE_FILE; EL_MODULE_TUPLE

	SHARED_DEV_ENVIRON

feature -- Access

	Chinese_characters: ARRAYED_LIST [STRING_GENERAL]
		once
			create Result.make (64)
			across chinese_names as name loop
				Result.extend (name.item.characters)
			end
		end

	chinese_names: EL_ARRAYED_RESULT_LIST [STRING_32, like new_chinese_title]
			--
		do
			create Result.make (Chinese_text.split ('%N'), agent new_chinese_title)
		end

	English_titles: EL_STRING_8_LIST
		local
			txt_file: PLAIN_TEXT_FILE; done: BOOLEAN
		once
			create Result.make (64)
			create txt_file.make_open_read (Hexagrams_path)
			from until done loop
				txt_file.read_line
				if txt_file.end_of_file then
					done := True
				else
					Result.extend (txt_file.last_string.twin)
				end
			end
			txt_file.close
		end

	Hexagram_1_array: ARRAYED_LIST [ARRAY [READABLE_STRING_GENERAL]]
		once
			create Result.make_from_array (<<
				new_parts_array (1, File.line_one (Hexagrams_path))
			>>)
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
			chinese_name: like chinese_names.item
		do
			chinese_name := chinese_names [index]
			Result := << "Hex. #" + index.out, chinese_name.pinyin, chinese_name.characters, title >>
		end

	new_chinese_title (csv_line: STRING_32): TUPLE [pinyin, characters: STRING_32; number: INTEGER]
		do
			create Result
			Tuple.fill (Result, csv_line)
		end

feature -- Constants

	Chinese_text: STRING_32 = "[
		Qián, 乾, 1
		Kūn, 坤, 2
		Zhūn, 屯, 3
		Méng, 蒙, 4
		Xū, 需, 5
		Sòng, 訟, 6
		Shī, 師, 7
		Bǐ, 比, 8
		Xiǎo Chù, 小畜, 9
		Lǚ, 履, 10
		Tài, 泰, 11
		Pǐ, 否, 12
		Tóng Rén, 同人, 13
		Dà Yǒu, 大有, 14
		Qiān, 謙, 15
		Yù, 豫, 16
		Suí, 隨, 17
		Gŭ, 蠱, 18
		Lín, 臨, 19
		Guān, 觀, 20
		Shì Kè, 噬嗑, 21
		Bì, 賁, 22
		Bō, 剝, 23
		Fù, 復, 24
		Wú Wàng, 無妄, 25
		Dà Chù, 大畜, 26
		Yí, 頤, 27
		Dà Guò, 大過, 28
		Kǎn, 坎, 29
		Lí, 離, 30
		Xián, 咸, 31
		Héng, 恆, 32
		Dùn, 遯, 33
		Dà Zhuàng, 大壯, 34
		Jìn, 晉, 35
		Míng Yí, 明夷, 36
		Jiā Rén, 家人, 37
		Kuí, 睽, 38
		Jiǎn, 蹇, 39
		Xiè, 解, 40
		Sǔn, 損, 41
		Yì, 益, 42
		Guài, 夬, 43
		Gòu, 姤, 44
		Cuì, 萃, 45
		Shēng, 升, 46
		Kùn, 困, 47
		Jǐng, 井, 48
		Gé, 革, 49
		Dǐng, 鼎, 50
		Zhèn, 震, 51
		Gèn, 艮, 52
		Jiàn, 漸, 53
		Guī Mèi, 歸妹, 54
		Fēng, 豐, 55
		Lǚ, 履, 56
		Xùn, 巽, 57
		Duì, 兌, 58
		Huàn, 渙, 59
		Jié, 節, 60
		Zhōng Fú, 中孚, 61
		Xiǎo Guò, 小過, 62
		Jì Jì, 既濟, 63
		Wèi Jì, 未濟, 64
	]"

	Hexagrams_path: FILE_PATH
		once
			Result := Dev_environ.Eiffel_loop_dir + "test/data/txt/hexagrams.txt"
		end

end