note
	description: "Summary description for {EL_PANGO_CAIRO_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

deferred class
	EL_PANGO_CAIRO_I

inherit
	EL_MEMORY

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
