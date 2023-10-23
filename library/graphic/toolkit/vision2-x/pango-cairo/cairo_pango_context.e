note
	description: "Pango context created by **pango_cairo_create_context** in `<pango/pangocairo.h>'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-04 14:32:50 GMT (Wednesday 4th October 2023)"
	revision: "1"

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
		do
			internal_font.set_family (name)
			Result := is_font_loadable
		end

	valid_font_family_utf_8 (name_utf_8: READABLE_STRING_8): BOOLEAN
		do
			internal_font.set_family_utf_8 (name_utf_8)
			Result := is_font_loadable
		end

feature {NONE} -- Implementation

	is_font_loadable: BOOLEAN
		local
			p_font: POINTER
		do
			p_font := Pango.new_font (self_ptr, internal_font.item)
			if is_attached (p_font) then
				Gobject.unref (p_font)
				Result := True
			end
		end

feature {NONE} -- Internal attributes

	internal_font: CAIRO_PANGO_FONT
end