note
	description: "Dialog style information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-04 13:28:10 GMT (Wednesday 4th August 2021)"
	revision: "3"

class
	EL_DIALOG_STYLE

inherit
	SD_COLOR_HELPER
		export
			{NONE} all
		end

	EL_MODULE_COLOR
		rename
			Color as Mod_color
		end

	EL_MODULE_GUI

create
	make

feature {NONE} -- Initialization

	make
		do
			create label_font
			progress_meter_font := label_font

			create title_font
			title_font.set_weight (GUI.Weight_bold)
			title_background_pixmap := Default_pixmap
			application_icon_pixmap := Default_pixmap

			create color
			color.button_box := Default_color
			color.content_area := Mod_color.default_background
			color.default_border := Mod_color.gray
			color.progress_bar := Mod_color.Blue

			new_button_pixmap_set := Default_new_button_pixmap_set
		end

feature -- Colors

	border_color: EL_COLOR
		do
			if has_content_area_color then
				Result := color_with_lightness (color.content_area, -0.2).twin
			else
				Result := color.default_border
			end
		end

	color: TUPLE [button_box, content_area, default_border, progress_bar: EL_COLOR]

feature -- Pixmaps

	application_icon_pixmap: EV_PIXMAP

	title_background_pixmap: EV_PIXMAP

feature -- Fonts

	label_font: EV_FONT

	title_font: EV_FONT

	progress_meter_font: EV_FONT

feature -- Set pixmap

	set_application_icon_pixmap (a_application_icon_pixmap: EV_PIXMAP)
		do
			application_icon_pixmap := a_application_icon_pixmap
		end

	set_new_button_pixmap_set (a_new_button_pixmap_set: like new_button_pixmap_set)
		do
			new_button_pixmap_set := a_new_button_pixmap_set
		end

	set_title_background_pixmap (a_title_background_pixmap: EV_PIXMAP)
		do
			title_background_pixmap := a_title_background_pixmap
		end

feature -- Set fonts

	set_label_font (a_label_font: EV_FONT)
		do
			if progress_meter_font = label_font then
				progress_meter_font := a_label_font
			end
			label_font := a_label_font
		end

	set_progress_meter_font (a_progress_meter_font: EV_FONT)
		do
			progress_meter_font := a_progress_meter_font
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
			Result := color.button_box /= Default_color
		end

	has_content_area_color: BOOLEAN
		do
			Result := color.content_area /= Default_color
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