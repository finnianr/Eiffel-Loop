note
	description: "Summary description for {EL_PANGO_CAIRO_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_PANGO_CAIRO_API

inherit
	EL_DYNAMIC_MODULE

	EL_PANGO_CAIRO_I
		undefine
			dispose
		end

	EL_PANGO_CAIRO_C_API
		undefine
			dispose
		end
create
	make

feature -- Factory

	create_layout (context_ptr: POINTER): POINTER
		do
			Result := pango_cairo_create_layout (pointer_create_layout, context_ptr)
		end

feature -- Basic operations

	show_layout (context_ptr, layout: POINTER)
		do
			pango_cairo_show_layout (pointer_show_layout, context_ptr, layout)
		end

	update_layout (context_ptr, layout: POINTER)
		do
			pango_cairo_update_layout (pointer_update_layout, context_ptr, layout)
		end

feature {NONE} -- Implementation

	assign_pointers
		do
			pointer_create_layout := function_pointer ("create_layout")
			pointer_show_layout := function_pointer ("show_layout")
			pointer_update_layout := function_pointer ("update_layout")
		end

	pointer_create_layout: POINTER

	pointer_show_layout: POINTER

	pointer_update_layout: POINTER

feature {NONE} -- Constants

	Module_name: STRING = "libpangocairo-1.0-0"

	Name_prefix: STRING = "pango_cairo_"

end
