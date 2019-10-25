note
	description: "Tag info test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-25 12:40:56 GMT (Friday   25th   October   2019)"
	revision: "2"

class
	TAG_INFO_TEST_SET

inherit
	ID3_TEST_SET

feature -- Tests

	test_read_id3
		local
			mp3: TL_MPEG_FILE
		do

		end

feature {NONE} -- Constants

	Filter: STRING = "*"

end
