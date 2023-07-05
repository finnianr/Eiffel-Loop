note
	description: "Dialog with optional title bar decorated by pixmap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-05 14:03:22 GMT (Wednesday 5th July 2023)"
	revision: "5"

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
			if attached pixmaped_title as l_title then
				content_box.extend_unexpanded (l_title.label)
			end
		end

feature -- Element change

	set_title (text: separate READABLE_STRING_GENERAL)
		do
			Precursor (text)
			if text.count = 0 then
				pixmaped_title := Void

			elseif attached pixmaped_title as l_title then
				l_title.label.set_text (text)
			else
				pixmaped_title := new_pixmaped_title (text)
			end
		end

feature {NONE} -- Factory

	new_pixmaped_title (text: READABLE_STRING_GENERAL): TUPLE [label: EL_LABEL_PIXMAP; drag_bar: EL_WINDOW_DRAG]
		local
			label: EL_LABEL_PIXMAP; drag_bar: EL_WINDOW_DRAG
		do
			create label.make_with_text_and_font (text, style.title_font)
			label.set_width_for_border (model.layout.border_inner_width_cms)
			if style.has_title_background_pixmap then
				label.set_tile_pixmap (style.title_background_pixmap)
			end
			label.align_text_center
			create drag_bar.make (Current, label)

			Result := [label, drag_bar]
		end

feature {NONE} -- Internal attributes

	pixmaped_title: detachable like new_pixmaped_title

end