note
	description: "Pango Cairo font families"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-02 11:10:00 GMT (Monday 2nd October 2023)"
	revision: "1"

class
	CAIRO_PANGO_FONT_FAMILIES

inherit
	EL_OWNED_C_OBJECT
		rename
			self_ptr as item
		export
			{ANY} item
		end

	CAIRO_SHARED_PANGO_API

create
	make

feature {NONE} -- Initialization

	make
		do
		end

feature {NONE} -- Disposal

	c_free (this: POINTER)
			--
		do
			if not is_in_final_collect then
--				Pango.font_description_free (this)
			end
		end
end