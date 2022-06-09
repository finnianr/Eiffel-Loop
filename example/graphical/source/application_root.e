note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-09 16:17:22 GMT (Thursday 9th June 2022)"
	revision: "15"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		FRACTAL_APP,
		POST_CARD_VIEWER_APP,
		PANGO_CAIRO_TEST_APP,
		QUANTUM_BALL_ANIMATION_APP,
		SLIDE_SHOW_APP
	]

create
	make

feature {NONE} -- Compile also

	cairo: TUPLE [CAIRO_SHARED_GDK_API, CAIRO_SHARED_GDK_PIXBUF_API]
		do
			create Result
		end

	compile: TUPLE [EL_SEPARATE_PROGRESS_DISPLAY]
		do
			create Result
		end

	dialogs: TUPLE [
		EL_APPLY_CHANGES_CONFIRMATION_DIALOG, EL_SAVE_CHANGES_CONFIRMATION_DIALOG,
		EL_FILE_OPEN_DIALOG, EL_FILE_SAVE_DIALOG, EL_PROGRESS_DIALOG,
		EL_MODELED_DIALOG, EL_MODELED_INFORMATION_DIALOG, EL_MODELED_COLUMNS_DIALOG,
		EL_HYPERLINK_MENU [EL_NAMEABLE [ZSTRING]]
	]
		do
			create Result
		end

	containers: TUPLE [
		EL_AUTO_CELL_HIDING_HORIZONTAL_BOX,
		EL_BUTTON_PROGRESS_BOX [EV_BUTTON],
		EL_CENTERED_VIEWPORT,
		EL_TAB_BOOK [EL_BOX],
		EL_WIDGET_PROGRESS_BOX [EV_WIDGET]
	]
		do
			create Result
		end

	primitives: TUPLE [EL_RED_GREEN_STATUS_LIGHTS_DRAWING_AREA, EL_TIMED_PROGRESS_BAR]
		do
			create Result
		end

	widgets: TUPLE [EL_SCALE_SLIDER, EL_MIXED_FONT_LABEL_AREA, EL_MIXED_STYLE_FIXED_LABELS]
		do
			create Result
		end
end