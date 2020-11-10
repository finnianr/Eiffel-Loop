note
	description: "Pango cairo test app"
	notes: "[
		Launch

			el_graphical -pango_cairo_test
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-10 10:16:25 GMT (Tuesday 10th November 2020)"
	revision: "8"

class
	PANGO_CAIRO_TEST_APP

inherit
	EL_LOGGED_SUB_APPLICATION

create
	make

feature {NONE} -- Initialization

	initialize
			--
		do
			create gui.make (False)
		end

feature -- Basic operations

	run
		do
			gui.launch
		end

feature {NONE} -- Implementation

	gui: EL_VISION_2_USER_INTERFACE [PANGO_CAIRO_TEST_MAIN_WINDOW]

	log_filter_set: EL_LOG_FILTER_SET [like Current, PANGO_CAIRO_TEST_MAIN_WINDOW]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Description: STRING = "Tests pangocairo drawing in EL_DRAWABLE_PIXEL_BUFFER "

end