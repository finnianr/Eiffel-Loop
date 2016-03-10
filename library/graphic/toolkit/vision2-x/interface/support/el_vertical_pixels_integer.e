note
	description: "Summary description for {EL_VERTICAL_PIXELS_INTEGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
