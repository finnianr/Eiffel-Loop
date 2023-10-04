note
	description: "Pango Cairo font families"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
