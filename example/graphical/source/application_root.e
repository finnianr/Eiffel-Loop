note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-12 8:50:33 GMT (Monday 12th April 2021)"
	revision: "10"

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

feature {NONE} -- Constants

	Compile_also: TUPLE [EL_SEPARATE_PROGRESS_DISPLAY, EL_MIXED_FONT_LABEL_AREA, EL_MIXED_STYLE_FIXED_LABELS]
		once
			create Result
		end

end