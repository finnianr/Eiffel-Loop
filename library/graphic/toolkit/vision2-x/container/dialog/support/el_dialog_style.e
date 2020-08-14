note
	description: "Dialog style information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-10 17:53:16 GMT (Monday 10th August 2020)"
	revision: "1"

class
	EL_DIALOG_STYLE

inherit
	SD_COLOR_HELPER
		export
			{NONE} all
		end

	EL_MODULE_COLOR

	EL_MODULE_GUI

create
	make

feature {NONE} -- Initialization

	make
		do
			create label_font
			create title_font
			title_font.set_weight (GUI.Weight_bold)
			title_background_pixmap := Default_pixmap
			application_icon_pixmap := Default_pixmap
			content_area_color := Default_color
			default_border_color := Color.gray
			button_box_color := Default_color
			new_button_pixmap_set := Default_new_button_pixmap_set
		end

feature -- Colors

	border_color: EL_COLOR
		do
			if has_content_area_color then
				Result := color_with_lightness (content_area_color, -0.2).twin
			else
				Result := default_border_color
			end
		end

	button_box_color: EL_COLOR

	content_area_color: EL_COLOR

	default_border_color: EL_COLOR

feature -- Access

	application_icon_pixmap: EV_PIXMAP

	label_font: EV_FONT

	title_background_pixmap: EV_PIXMAP

	title_font: EV_FONT

feature -- Element change

	set_application_icon_pixmap (a_application_icon_pixmap: EV_PIXMAP)
		do
			application_icon_pixmap := a_application_icon_pixmap
		end

	set_content_area_color (a_content_area_color: EL_COLOR)
		do
			content_area_color := a_content_area_color
		end

	set_default_border_color (a_default_border_color: EL_COLOR)
		do
			default_border_color := a_default_border_color
		end

	set_label_font (a_label_font: EV_FONT)
		do
			label_font := a_label_font
		end

	set_new_button_pixmap_set (a_new_button_pixmap_set: like new_button_pixmap_set)
		do
			new_button_pixmap_set := a_new_button_pixmap_set
		end

	set_title_background_pixmap (a_title_background_pixmap: EV_PIXMAP)
		do
			title_background_pixmap := a_title_background_pixmap
		end

	set_title_font (a_title_font: EV_FONT)
		do
			title_font := a_title_font
		end

feature -- Factory

	new_button_pixmap_set: like Default_new_button_pixmap_set
		-- factory function for making decorated buttons of type `EL_DECORATED_BUTTON'

feature -- Status query

	has_application_icon_pixmap: BOOLEAN
		do
			Result := application_icon_pixmap /= Default_pixmap
		end

	has_button_box_color: BOOLEAN
		do
			Result := button_box_color /= Default_color
		end

	has_content_area_color: BOOLEAN
		do
			Result := content_area_color /= Default_color
		end

	has_new_button_pixmap_set: BOOLEAN
		do
			Result := new_button_pixmap_set /= Default_new_button_pixmap_set
		end

	has_title_background_pixmap: BOOLEAN
		do
			Result := title_background_pixmap /= Default_pixmap
		end

feature {NONE} -- Constants

	frozen Default_color: EL_COLOR
			-- Should not be redefined as it represents default dialog color
		once
			create Result
		end

	frozen Default_new_button_pixmap_set: FUNCTION [READABLE_STRING_GENERAL, EL_COLOR, EL_SVG_TEXT_BUTTON_PIXMAP_SET]
		once
			Result := agent (text: READABLE_STRING_GENERAL; a_background_color: EL_COLOR): EL_SVG_TEXT_BUTTON_PIXMAP_SET
				require
					never_called: False
				do
				end
		end

	frozen Default_pixmap: EV_PIXMAP
		once
			create Result.make_with_size (1, 1)
		end

end
