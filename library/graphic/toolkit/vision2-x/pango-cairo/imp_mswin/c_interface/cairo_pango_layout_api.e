note
	description: "Windows implemenation of [$source CAIRO_PANGO_LAYOUT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-30 14:47:52 GMT (Monday 30th May 2022)"
	revision: "9"

class
	CAIRO_PANGO_LAYOUT_API

inherit
	EL_DYNAMIC_MODULE [CAIRO_PANGO_LAYOUT_API_POINTERS]

	CAIRO_PANGO_LAYOUT_I

	CAIRO_PANGO_LAYOUT_C_API

create
	make

feature -- Factory

	new (context_ptr: POINTER): POINTER
		do
			Result := pango_cairo_create_layout (api.create_layout, context_ptr)
		end

feature -- Basic operations

	show (context_ptr, layout: POINTER)
		do
			pango_cairo_show_layout (api.show_layout, context_ptr, layout)
		end

	update (context_ptr, layout: POINTER)
		do
			pango_cairo_update_layout (api.update_layout, context_ptr, layout)
		end

feature {NONE} -- Constants

	Module_name: STRING = "libpangocairo-1.0-0"

	Name_prefix: STRING = "pango_cairo_"

end