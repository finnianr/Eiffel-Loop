note
	description: "Chinese names for I Ching hexagrams"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-28 10:52:38 GMT (Tuesday 28th March 2023)"
	revision: "17"

expanded class
	HEXAGRAM_NAMES

inherit
	EL_EXPANDED_ROUTINES

feature -- Access

	i_th_combined (i: INTEGER): ZSTRING
		-- combined pinyin and hanzi characters
		-- Eg. "Qián (屯)"
		do
			Result := Combined #$ [i_th_cell (i, 2), i_th_cell (i, 3)]
		end

	i_th_cell (i, column: INTEGER): IMMUTABLE_STRING_32
		require
			valid_index: 1 <= i and i <= 64
			valid_column: 1 <= column and column <= 3
			valid_manifest_row: i = Name_split_list.i_th ((i - 1) * 3 + 1).out.to_integer
		local
			j: INTEGER
		do
			j := (i - 1) * 3 + column
			Result := Name_split_list.i_th (j)
		end

	i_th_pinyin_name (i: INTEGER): IMMUTABLE_STRING_32
		do
			Result := i_th_cell (i, 2)
		end

	i_th_hanzi_characters (i: INTEGER): IMMUTABLE_STRING_32
		do
			Result := i_th_cell (i, 3)
		end

feature -- Constants

	Name_manifest: STRING_32 = "[
		1, Qián, 乾,
		2, Kūn, 坤,
		3, Zhūn, 屯,
		4, Méng, 蒙,
		5, Xū, 需,
		6, Sòng, 訟,
		7, Shī, 師,
		8, Bǐ, 比,
		9, Xiǎo Chù, 小畜,
		10, Lǚ, 履,
		11, Tài, 泰,
		12, Pǐ, 否,
		13, Tóng Rén, 同人,
		14, Dà Yǒu, 大有,
		15, Qiān, 謙,
		16, Yù, 豫,
		17, Suí, 隨,
		18, Gŭ, 蠱,
		19, Lín, 臨,
		20, Guān, 觀,
		21, Shì Kè, 噬嗑,
		22, Bì, 賁,
		23, Bō, 剝,
		24, Fù, 復,
		25, Wú Wàng, 無妄,
		26, Dà Chù, 大畜,
		27, Yí, 頤,
		28, Dà Guò, 大過,
		29, Kǎn, 坎,
		30, Lí, 離,
		31, Xián, 咸,
		32, Héng, 恆,
		33, Dùn, 遯,
		34, Dà Zhuàng, 大壯,
		35, Jìn, 晉,
		36, Míng Yí, 明夷,
		37, Jiā Rén, 家人,
		38, Kuí, 睽,
		39, Jiǎn, 蹇,
		40, Xiè, 解,
		41, Sǔn, 損,
		42, Yì, 益,
		43, Guài, 夬,
		44, Gòu, 姤,
		45, Cuì, 萃,
		46, Shēng, 升,
		47, Kùn, 困,
		48, Jǐng, 井,
		49, Gé, 革,
		50, Dǐng, 鼎,
		51, Zhèn, 震,
		52, Gèn, 艮,
		53, Jiàn, 漸,
		54, Guī Mèi, 歸妹,
		55, Fēng, 豐,
		56, Lǚ, 旅,
		57, Xùn, 巽,
		58, Duì, 兌,
		59, Huàn, 渙,
		60, Jié, 節,
		61, Zhōng Fú, 中孚,
		62, Xiǎo Guò, 小過,
		63, Jì Jì, 既濟,
		64, Wèi Jì, 未濟
	]"

	Name_split_list: EL_SPLIT_IMMUTABLE_STRING_32_LIST
		once
			create Result.make_shared_adjusted (Name_manifest, ',', {EL_SIDE}.Left)
		end

	Combined: ZSTRING
		once
			Result := "%S (%S)"
		end

end