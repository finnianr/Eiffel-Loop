note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-19 6:31:34 GMT (Friday 19th July 2024)"
	revision: "22"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		EDIT_HISTORY_TEST_APP,
		FRACTAL_APP,
		POST_CARD_VIEWER_APP,
		PANGO_CAIRO_TEST_APP,
		QUANTUM_BALL_ANIMATION_APP,
		SLIDE_SHOW_APP
	]

	COMPILE_CLASSES

create
	make

end