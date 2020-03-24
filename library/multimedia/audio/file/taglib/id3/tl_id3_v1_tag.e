note
	description: "ID3 ver. 1.x Tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-24 8:46:27 GMT (Tuesday 24th March 2020)"
	revision: "11"

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
