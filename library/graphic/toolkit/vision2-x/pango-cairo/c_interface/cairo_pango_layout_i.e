note
	description: "Pango cairo text layout interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-15 20:41:59 GMT (Wednesday 15th September 2021)"
	revision: "8"

deferred class
	CAIRO_PANGO_LAYOUT_I

inherit
	EL_C_API_ROUTINES

feature -- Factory

	new_layout (context_ptr: POINTER): POINTER
		require
			is_attached: is_attached (context_ptr)
		deferred
		end

feature -- Basic operations

	show_layout (context_ptr, layout: POINTER)
		require
			is_attached: is_attached (context_ptr)
		deferred
		end

	update_layout (context_ptr, layout: POINTER)
		require
			is_attached: is_attached (context_ptr)
		deferred
		end

end