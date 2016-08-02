note
	description: "Summary description for {EL_VERTICAL_PIXELS_INTEGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "1"


expanded class
	EL_VERTICAL_PIXELS_INTEGER

inherit
	EL_VERTICAL_PIXELS_INTEGER_REF

create
	default_create, make_with_cms, set_item

convert
	make_with_cms ({DOUBLE}), set_item ({INTEGER}),
	item: {INTEGER}

end