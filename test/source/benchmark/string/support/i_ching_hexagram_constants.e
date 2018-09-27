note
	description: "I ching hexagram constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	I_CHING_HEXAGRAM_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		local
			index: INTEGER; chinese_name: like chinese_names.item
			txt_file: PLAIN_TEXT_FILE; done: BOOLEAN
		do
			create chinese_characters.make (chinese_names.count)
			across chinese_names as name loop
				chinese_characters.extend (name.item.characters)
			end

			create english_titles.make (64)
			create txt_file.make_open_read (Hexagrams_path.expanded_path)
			from until done loop
				txt_file.read_line
				if txt_file.end_of_file then
					done := True
				else
					english_titles.extend (txt_file.last_string.twin)
				end
			end
			txt_file.close

			create string_arrays.make (64)
			across english_titles as title loop
				index := title.cursor_index
				chinese_name := chinese_names [index]
				string_arrays.extend (<< "Hex. #" + index.out, chinese_name.pinyin, chinese_name.characters, title.item >>)
			end
		end

feature -- Access

	chinese_characters: ARRAYED_LIST [STRING_GENERAL]

	english_titles: ARRAYED_LIST [STRING]

	string_arrays: ARRAYED_LIST [ARRAY [STRING_GENERAL]]

feature -- Constants

	chinese_names: ARRAY [TUPLE [pinyin, characters: STRING_32]]
			--
		once
			Result := <<
				[{STRING_32} "Qián",			{STRING_32} "乾"],		-- 1
				[{STRING_32} "Kūn",			{STRING_32} "坤"],		-- 2
				[{STRING_32} "Zhūn",			{STRING_32} "屯"],		-- 3
				[{STRING_32} "Méng",			{STRING_32} "蒙"],		-- 4
				[{STRING_32} "Xū",			{STRING_32} "需"],		-- 5
				[{STRING_32} "Sòng",			{STRING_32} "訟"],		-- 6
				[{STRING_32} "Shī",			{STRING_32} "師"],		-- 7
				[{STRING_32} "Bǐ",			{STRING_32} "比"],		-- 8
				[{STRING_32} "Xiǎo Chù",	{STRING_32} "小畜"],	-- 9
				[{STRING_32} "Lǚ",			{STRING_32} "履"],		-- 10
				[{STRING_32} "Tài",			{STRING_32} "泰"],		-- 11
				[{STRING_32} "Pǐ",			{STRING_32} "否"],		-- 12
				[{STRING_32} "Tóng Rén",	{STRING_32} "同人"],	-- 13
				[{STRING_32} "Dà Yǒu",		{STRING_32} "大有"],	-- 14
				[{STRING_32} "Qiān",			{STRING_32} "謙"],		-- 15
				[{STRING_32} "Yù",			{STRING_32} "豫"],		-- 16
				[{STRING_32} "Suí",			{STRING_32} "隨"],		-- 17
				[{STRING_32} "Gŭ",			{STRING_32} "蠱"],		-- 18
				[{STRING_32} "Lín",			{STRING_32} "臨"],		-- 19
				[{STRING_32} "Guān",			{STRING_32} "觀"],		-- 20
				[{STRING_32} "Shì Kè",		{STRING_32} "噬嗑"],	-- 21
				[{STRING_32} "Bì",			{STRING_32} "賁"],		-- 22
				[{STRING_32} "Bō",			{STRING_32} "剝"],		-- 23
				[{STRING_32} "Fù",			{STRING_32} "復"],		-- 24
				[{STRING_32} "Wú Wàng",		{STRING_32} "無妄"],	-- 25
				[{STRING_32} "Dà Chù",		{STRING_32} "大畜"],	-- 26
				[{STRING_32} "Yí",			{STRING_32} "頤"],		-- 27
				[{STRING_32} "Dà Guò",		{STRING_32} "大過"],	-- 28
				[{STRING_32} "Kǎn",			{STRING_32} "坎"],		-- 29
				[{STRING_32} "Lí",			{STRING_32} "離"],		-- 30
				[{STRING_32} "Xián",			{STRING_32} "咸"],		-- 31
				[{STRING_32} "Héng",			{STRING_32} "恆"],		-- 32
				[{STRING_32} "Dùn",			{STRING_32} "遯"],		-- 33
				[{STRING_32} "Dà Zhuàng",	{STRING_32} "大壯"],	-- 34
				[{STRING_32} "Jìn",			{STRING_32} "晉"],		-- 35
				[{STRING_32} "Míng Yí",		{STRING_32} "明夷"],	-- 36
				[{STRING_32} "Jiā Rén",		{STRING_32} "家人"],	-- 37
				[{STRING_32} "Kuí",			{STRING_32} "睽"],		-- 38
				[{STRING_32} "Jiǎn",			{STRING_32} "蹇"],		-- 39
				[{STRING_32} "Xiè",			{STRING_32} "解"],		-- 40
				[{STRING_32} "Sǔn",			{STRING_32} "損"],		-- 41
				[{STRING_32} "Yì",			{STRING_32} "益"],		-- 42
				[{STRING_32} "Guài",			{STRING_32} "夬"],		-- 43
				[{STRING_32} "Gòu",			{STRING_32} "姤"],		-- 44
				[{STRING_32} "Cuì",			{STRING_32} "萃"],		-- 45
				[{STRING_32} "Shēng",		{STRING_32} "升"],		-- 46
				[{STRING_32} "Kùn",			{STRING_32} "困"],		-- 47
				[{STRING_32} "Jǐng",			{STRING_32} "井"],		-- 48
				[{STRING_32} "Gé",			{STRING_32} "革"],		-- 49
				[{STRING_32} "Dǐng",			{STRING_32} "鼎"],		-- 50
				[{STRING_32} "Zhèn",			{STRING_32} "震"],		-- 51
				[{STRING_32} "Gèn",			{STRING_32} "艮"],		-- 52
				[{STRING_32} "Jiàn",			{STRING_32} "漸"],		-- 53
				[{STRING_32} "Guī Mèi",		{STRING_32} "歸妹"],	-- 54
				[{STRING_32} "Fēng",			{STRING_32} "豐"],		-- 55
				[{STRING_32} "Lǚ",			{STRING_32} "履"],		-- 56
				[{STRING_32} "Xùn",			{STRING_32} "巽"],		-- 57
				[{STRING_32} "Duì",			{STRING_32} "兌"],		-- 58
				[{STRING_32} "Huàn",			{STRING_32} "渙"],		-- 59
				[{STRING_32} "Jié",			{STRING_32} "節"],		-- 60
				[{STRING_32} "Zhōng Fú",	{STRING_32} "中孚"],	-- 61
				[{STRING_32} "Xiǎo Guò",	{STRING_32} "小過"],	-- 62
				[{STRING_32} "Jì Jì",		{STRING_32} "既濟"],	-- 63
				[{STRING_32} "Wèi Jì",		{STRING_32} "未濟"] 	-- 64
			>>
		end

	Hexagrams_path: EL_FILE_PATH
		once
			Result := "$EIFFEL_LOOP/test/data/hexagrams.txt"
		end

end
