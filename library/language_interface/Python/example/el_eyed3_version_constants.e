note
	description: "Summary description for {EL_EYED3_VERSION_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_EYED3_VERSION_CONSTANTS

feature -- Major versions

	ID3_V1   : INTEGER = 0x10
	ID3_V2   : INTEGER = 0x20

feature -- Minor versions 1.x

	ID3_V1_0 : INTEGER = 0x11
	ID3_V1_1 : INTEGER = 0x12

feature -- Minor versions 2.x

	ID3_V2_2 : INTEGER = 0x21
	ID3_V2_3 : INTEGER = 0x22
	ID3_V2_4 : INTEGER = 0x24

feature -- Constants

	Valid_ID3_versions: ARRAY [INTEGER]
			--
		once
			Result := << ID3_V1_0, ID3_V1_1, ID3_V2_2, ID3_V2_3, ID3_V2_4 >>
		end

end