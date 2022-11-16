note
	description: "Object that is reclaimed by a call to **g_object_unref**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

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