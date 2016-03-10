note
	description: "Summary description for {TEST_APP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PANGO_CAIRO_TEST_APP

inherit
	EL_SUB_APPLICATION
		redefine
			option_name
		end

create
	make

feature {NONE} -- Initialization

	initialize
			--
		do
			create gui.make
		end

feature -- Basic operations

	run
		do
			gui.launch
		end

feature {NONE} -- Implementation

	gui: EL_VISION2_USER_INTERFACE [PANGO_CAIRO_TEST_MAIN_WINDOW]

feature {NONE} -- Constants

	Option_name: STRING = "pangocairo"

	Description: STRING = "Tests pangocairo drawing in EL_DRAWABLE_PIXEL_BUFFER "

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{PANGO_CAIRO_TEST_APP}, "*"],
				[{PANGO_CAIRO_TEST_MAIN_WINDOW}, "*"]

			>>
		end

end
