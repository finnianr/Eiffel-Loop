note
	description: "Class for Debian package model experiment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 18:02:41 GMT (Wednesday 8th January 2020)"
	revision: "3"

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
