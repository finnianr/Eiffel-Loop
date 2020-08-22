note
	description: "Pango cairo test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-21 15:26:58 GMT (Friday 21st August 2020)"
	revision: "5"

class
	PANGO_CAIRO_TEST_APP

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			option_name
		end

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

feature {NONE} -- Constants

	Option_name: STRING = "pangocairo"

	Description: STRING = "Tests pangocairo drawing in EL_DRAWABLE_PIXEL_BUFFER "

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{PANGO_CAIRO_TEST_APP}, "*"],
				[{PANGO_CAIRO_TEST_MAIN_WINDOW}, "*"]

			>>
		end

end
