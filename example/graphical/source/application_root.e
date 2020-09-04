note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-03 17:20:51 GMT (Thursday 3rd September 2020)"
	revision: "8"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Constants

	Applications: TUPLE [
		FRACTAL_APP,
		POST_CARD_VIEWER_APP,
		PANGO_CAIRO_TEST_APP,
		QUANTUM_BALL_ANIMATION_APP
	]
		once
			create Result
		end

	Compile_also: TUPLE [EL_SEPARATE_PROGRESS_DISPLAY, EL_MIXED_FONT_LABEL_AREA, EL_MIXED_STYLE_FIXED_LABELS]
		once
			create Result
		end

end
