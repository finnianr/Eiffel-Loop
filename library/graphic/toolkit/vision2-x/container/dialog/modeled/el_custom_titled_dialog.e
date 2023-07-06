note
	description: "Dialog with an optional faux-title bar decorated by a background pixmap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-05 19:02:15 GMT (Wednesday 5th July 2023)"
	revision: "6"

class
	EL_CUSTOM_TITLED_DIALOG

inherit
	EV_UNTITLED_DIALOG
		undefine
			Default_pixmaps, show_modal_to_window
		redefine
			set_title
		end

	EL_STANDARD_DIALOG
		undefine
			set_title, create_implementation
		redefine
			add_title_to, has_title_bar
		end

create
	make

feature -- Status query

	has_title_bar: BOOLEAN
		-- `True' if dialog has standard OS title bar
		do
			Result := False
		end

feature -- Basic operations

	add_title_to (content_box: EL_VERTICAL_BOX)
		do
			if attached title_bar as bar then
				content_box.extend_unexpanded (bar)
			end
		end

feature -- Element change

	set_title (text: separate READABLE_STRING_GENERAL)
		do
			Precursor (text)
			if text.count = 0 then
				title_bar := Void

			elseif attached title_bar as bar then
				bar.set_text (text)
			else
				title_bar := new_title_bar (text)
			end
		end

feature {NONE} -- Factory

	new_title_bar (text: READABLE_STRING_GENERAL): EL_LABEL_PIXMAP
		do
			create Result.make_with_text_and_font (text, style.title_font)
			Result.use_as_drag_bar (Current)

			Result.set_width_for_border (model.layout.border_inner_width_cms)
			if style.has_title_background_pixmap then
				Result.set_tile_pixmap (style.title_background_pixmap)
			end
			Result.align_text_center
		end

feature {NONE} -- Internal attributes

	title_bar: detachable like new_title_bar

end