note
	description: "Class for Debian package model experiment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	DEBIAN_VERSION

create
	make

convert
	make ({STRING})

feature {NONE} -- Initialization

	make (str: STRING)
		do
		end

feature -- Status query

	less_than_or_equal alias "<=" (other: DEBIAN_VERSION): BOOLEAN
		do
		end

	greater_than_or_equal alias ">=" (other: DEBIAN_VERSION): BOOLEAN
		do
		end

	same alias "#is" (other: DEBIAN_VERSION): BOOLEAN
		do
		end

end