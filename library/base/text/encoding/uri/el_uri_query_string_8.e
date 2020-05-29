note
	description: "URI query string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-28 8:09:06 GMT (Thursday 28th May 2020)"
	revision: "9"

class
	EL_URI_QUERY_STRING_8

inherit
	EL_URI_STRING_8

create
	make_encoded, make_empty, make

convert
	make_encoded ({STRING})

end
