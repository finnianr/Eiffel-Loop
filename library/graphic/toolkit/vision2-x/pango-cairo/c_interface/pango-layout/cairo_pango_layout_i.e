note
	description: "Pango cairo text layout interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 9:25:06 GMT (Tuesday 9th January 2024)"
	revision: "12"

deferred class
	CAIRO_PANGO_LAYOUT_I

inherit
	EL_MEMORY_ROUTINES

	EL_OS_DEPENDENT

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