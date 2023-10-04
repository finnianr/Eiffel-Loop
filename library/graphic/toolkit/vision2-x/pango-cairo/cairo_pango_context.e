note
	description: "Pango context created by **pango_cairo_create_context** in `<pango/pangocairo.h>'"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CAIRO_PANGO_CONTEXT

inherit
	CAIRO_OWNED_G_OBJECT

	CAIRO_SHARED_PANGO_LAYOUT_API

	CAIRO_SHARED_PANGO_API

create
	make

feature {NONE} -- Initialization

	make (drawable: CAIRO_DRAWABLE_CONTEXT_I)
		do
			make_from_pointer (Pango_layout.new_pango_context (drawable.context))
			create internal_font.make_default
		end

feature -- Status query

	valid_font_family (name: READABLE_STRING_GENERAL): BOOLEAN
		local
			p_font: POINTER
		do
			internal_font.set_family (name)
			p_font := Pango.new_font (self_ptr, internal_font.item)
			if is_attached (p_font) then
				Gobject.unref (p_font)
				Result := True
			end
		end

feature {NONE} -- Internal attributes

	internal_font: CAIRO_PANGO_FONT
end
