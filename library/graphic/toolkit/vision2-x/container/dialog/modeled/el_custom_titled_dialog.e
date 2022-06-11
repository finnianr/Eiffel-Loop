note
	description: "Dialog with optional title bar decorated by pixmap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-11 8:32:07 GMT (Saturday 11th June 2022)"
	revision: "2"

class
	EL_CUSTOM_TITLED_DIALOG

inherit
	EV_UNTITLED_DIALOG
		undefine
			show_modal_to_window
		redefine
			set_title
		end

	EL_DIALOG
		undefine
			set_title, create_implementation
		end

create
	make

feature -- Access

	title_label: detachable EL_LABEL_PIXMAP

feature -- Element change

	set_title (a_title: separate READABLE_STRING_GENERAL)
		do
			Precursor (a_title)
			if attached title_label as label then
				if not label.text.same_string (a_title) then
					label.set_text (a_title)
				end
			elseif a_title.count > 0 then
				title_label := new_title_label
				create title_bar_drag.make (Current, title_label)
			end
		end

feature {NONE} -- Factory

	new_title_label: EL_LABEL_PIXMAP
		do
			create Result.make_with_text_and_font (model.title, style.title_font)
			Result.set_width_for_border (model.layout.border_inner_width_cms)
			if style.has_title_background_pixmap then
				Result.set_tile_pixmap (style.title_background_pixmap)
			end
			Result.align_text_center
		end

feature {NONE} -- Internal attributes

	title_bar_drag: detachable EL_WINDOW_DRAG

end