note
	description: "Hexagram bitmaps"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2018 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "All rights reserved by copyright holder"
	date: "2018-09-20 10:06:24 GMT (Thursday 20th September 2018)"
	revision: "1"

class
	HEXAGRAM_BITMAPS

feature {NONE} -- Bitmaps

	Bitmap_line_6: INTEGER = 0b100_000

	Bitmap_line_5: INTEGER = 0b010_000

	Bitmap_line_1: INTEGER = 0b000_001

	Bit_mask_3_to_5: INTEGER = 0b011_100

	Bit_mask_2_to_4: INTEGER = 0b001_110

	Bitmap_hexagram_1: INTEGER = 0b111_111

feature {NONE} -- Trigrams

	Sky: INTEGER = 0b111

	Earth: INTEGER = 0b000

	Lightning: INTEGER = 0b001

	Mountain: INTEGER = 0b100

	Wind: INTEGER = 0b110

	Lake: INTEGER = 0b011

	Fire: INTEGER = 0b101

	Water: INTEGER = 0b010

end
