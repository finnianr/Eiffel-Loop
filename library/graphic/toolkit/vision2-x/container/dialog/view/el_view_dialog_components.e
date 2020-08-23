note
	description: "View dialog components"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-23 11:24:48 GMT (Sunday 23rd August 2020)"
	revision: "2"

deferred class
	EL_VIEW_DIALOG_COMPONENTS

inherit
	EV_ANY_HANDLER

	EL_DIALOG_CONSTANTS
		export
			{NONE} all
		end

	EL_MODULE_GUI

	EL_MODULE_ITERABLE

	EL_MODULE_KEY

	EL_MODULE_SCREEN

	EL_MODULE_VISION_2

feature -- Access

	model: EL_DIALOG_MODEL

feature {NONE} -- Factory

	new_button (a_text: READABLE_STRING_GENERAL): EL_BUTTON
		do
			if model.style.has_new_button_pixmap_set then
				create {EL_DECORATED_BUTTON} Result.make (new_text_pixmap (a_text))
			else
				create Result.make_with_text (a_text)
			end
		end

	new_default_button: like new_button
		do
			Result := new_button (model.default_button_text)
			Result.select_actions.extend (agent on_default)
		end

	new_label (a_text: READABLE_STRING_GENERAL): EL_LABEL
		do
			create Result.make_with_text (a_text)
			Result.set_background_color (model.style.color.content_area)
			Result.set_font (model.style.label_font)
			Result.align_text_left
		end

	new_progress_meter: EL_PROGRESS_METER
		do
			create Result.make (
				model.layout.progress_meter.bar_width_cms, model.layout.progress_meter.bar_height_cms,
				model.style.progress_meter_font
			)
			Result.set_bar_color (model.style.color.progress_bar)
			Result.label.set_text (model.progress_meter.label_text)
			Result.set_completion_text (model.progress_meter.completion_text)
		end

	new_text_pixmap (a_text: READABLE_STRING_GENERAL): EL_SVG_TEXT_BUTTON_PIXMAP_SET
		do
			Result := model.style.new_button_pixmap_set (a_text, model.style.color.content_area)
		end

	new_title_label: EL_LABEL_PIXMAP
		do
			create Result.make_with_text_and_font (internal_dialog.title, model.style.title_font)
			Result.set_width_for_border (model.layout.border_inner_width_cms)
			if model.style.has_title_background_pixmap then
				Result.set_tile_pixmap (model.style.title_background_pixmap)
			end
			Result.align_text_center
		end

	new_wrapped_label (a_text: READABLE_STRING_GENERAL; a_width: INTEGER): EL_WRAPPED_LABEL
		do
			create Result.make_to_width (a_text, model.style.label_font, a_width)
		end

feature {NONE} -- Implementation

	on_default
		deferred
		end

feature {EV_ANY_HANDLER} -- Implementation: attributes

	internal_dialog: EV_DIALOG

end
