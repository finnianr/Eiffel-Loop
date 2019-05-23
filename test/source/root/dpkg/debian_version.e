note
	description: "Experiment to see how Debian package info can be modeled in Eiffel"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-17 16:45:45 GMT (Friday 17th May 2019)"
	revision: "1"

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
