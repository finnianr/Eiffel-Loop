note
	description: "API function pointers for libpangocairo-1.0-0"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_PANGO_CAIRO_API_POINTERS

inherit
	EL_DYNAMIC_MODULE_POINTERS

create
	make

feature {EL_DYNAMIC_MODULE} -- Access

	create_layout: POINTER

	show_layout: POINTER

	update_layout: POINTER

end
