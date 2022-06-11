note
	description: "Installer UI component factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-11 13:56:42 GMT (Saturday 11th June 2022)"
	revision: "8"

class
	EL_UI_COMPONENT_FACTORY

inherit
	ANY

	EL_MODULE_DIRECTORY; EL_MODULE_GUI

	EL_SHARED_DEFAULT_PIXMAPS

feature {NONE} -- Factory

	new_button (a_text: READABLE_STRING_GENERAL; action: PROCEDURE): EV_BUTTON
		do
			create Result.make_with_text_and_action (a_text, action)
			Result.set_font (new_font (Size.tiny))
		end

	new_font (a_size: REAL): EL_FONT
		require
			valid_size: Font_size.has (a_size)
		do
			create Result.make_regular (font_family, a_size)
		end

	new_dialog_label_font: EL_FONT
		do
			Result := new_font (Size.tiny)
		end

	new_info_dialog (title, message: ZSTRING; is_error: BOOLEAN): EL_INFORMATION_DIALOG
		do
			create Result.make_with_text (message)
			Result.set_title (title)
			if is_error then
				Result.set_pixmap (Pixmaps.Error_pixmap)
			end
			Result.set_label_font (new_dialog_label_font)
		end

feature {NONE} -- Implementation

	font_family: STRING
		do
			Result := "Verdana"
		end

feature {NONE} -- Constants

	Font_size: ARRAY [REAL]
		-- descending font sizes from hugh to tiny
		once
			Result := << 4.5, 0.8, 0.6, 0.5, 0.4 >>
		end

	Size: TUPLE [hugh, large, medium, small, tiny: REAL]
		require
			valid_array_size: Font_size.count = 5
		once
			create Result
			across Font_size as l_size loop
				Result.put_real_32 (l_size.item, l_size.cursor_index)
			end
		end

end