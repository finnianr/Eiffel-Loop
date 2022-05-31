note
	description: "Pango cairo text layout interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-30 14:44:56 GMT (Monday 30th May 2022)"
	revision: "9"

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