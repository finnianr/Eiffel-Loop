note
	description: "Summary description for {EL_PANGO_CAIRO_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-03 15:58:22 GMT (Monday 3rd October 2016)"
	revision: "2"

deferred class
	EL_PANGO_CAIRO_I

inherit
	EL_POINTER_ROUTINES

feature -- Factory

	create_layout (context_ptr: POINTER): POINTER
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
