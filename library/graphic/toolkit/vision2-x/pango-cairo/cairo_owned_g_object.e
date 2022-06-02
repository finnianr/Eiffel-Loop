note
	description: "Object that is reclaimed by a call to **g_object_unref**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-02 9:56:29 GMT (Thursday 2nd June 2022)"
	revision: "1"

class
	CAIRO_OWNED_G_OBJECT

inherit
	EL_OWNED_C_OBJECT
		export
			{CAIRO_G_OBJECT_HANDLER} self_ptr
		end

	CAIRO_SHARED_GOBJECT_API

feature {NONE} -- Implementation

	c_free (this: POINTER)
			--
		do
			if not is_in_final_collect then
				Gobject.unref (self_ptr)
			end
		end

end