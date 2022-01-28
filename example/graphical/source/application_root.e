note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-27 18:32:45 GMT (Thursday 27th January 2022)"
	revision: "11"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		FRACTAL_APP,
		POST_CARD_VIEWER_APP,
		PANGO_CAIRO_TEST_APP,
		QUANTUM_BALL_ANIMATION_APP
	]

create
	make

feature {NONE} -- Compile also

	Compile_also: TUPLE [EL_SEPARATE_PROGRESS_DISPLAY]
		once
			create Result
		end

	Dialogs: TUPLE [
		EL_APPLY_CHANGES_CONFIRMATION_DIALOG, EL_SAVE_CHANGES_CONFIRMATION_DIALOG,
		EL_FILE_OPEN_DIALOG, EL_FILE_SAVE_DIALOG, EL_PROGRESS_DIALOG
	]
		once
			create Result
		end

	Containers: TUPLE [
		EL_AUTO_CELL_HIDING_HORIZONTAL_BOX,
		EL_BUTTON_PROGRESS_BOX [EV_BUTTON],
		EL_CENTERED_VIEWPORT,
		EL_TAB_BOOK [EL_BOX],
		EL_WIDGET_PROGRESS_BOX [EV_WIDGET]
	]
		once
			create Result
		end

	Primitives: TUPLE [EL_RED_GREEN_STATUS_LIGHTS_DRAWING_AREA, EL_TIMED_PROGRESS_BAR]
		once
			create Result
		end

	Widgets: TUPLE [EL_SCALE_SLIDER, EL_MIXED_FONT_LABEL_AREA, EL_MIXED_STYLE_FIXED_LABELS]
		once
			create Result
		end
end