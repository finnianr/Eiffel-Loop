note
	description: "Pango cairo text layout interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-04 8:30:05 GMT (Wednesday 4th October 2023)"
	revision: "11"

deferred class
	CAIRO_PANGO_LAYOUT_I

inherit
	EL_C_API_ROUTINES

feature -- Factory

	new (context_ptr: POINTER): POINTER
		require
			is_attached: is_attached (context_ptr)
		deferred
		end

	new_default_font_map: POINTER
		deferred
		end

	new_pango_context (context_ptr: POINTER): POINTER
		deferred
		end

feature -- Basic operations

	show (context_ptr, layout: POINTER)
		require
			is_attached: is_attached (context_ptr)
		deferred
		end

	update (context_ptr, layout: POINTER)
		require
			is_attached: is_attached (context_ptr)
		deferred
		end

end