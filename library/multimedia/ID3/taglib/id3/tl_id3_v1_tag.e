note
	description: "ID3 ver. 1.x Tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "12"

class
	TL_ID3_V1_TAG

inherit
	TL_ID3_TAG

create
	make

feature -- Constants

	Type: INTEGER = 1

	version: INTEGER = 1
		-- ID3 version number

end