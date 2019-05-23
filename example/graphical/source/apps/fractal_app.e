note
	description: "Simple geometric fractal defined by Pyxis configuration file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-20 13:10:11 GMT (Monday 20th May 2019)"
	revision: "1"

class
	FRACTAL_APP

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Initialization

	initialize
			--
		do
			create gui.make (True)
		end

feature -- Basic operations

	run
		do
			gui.launch
		end

feature {NONE} -- Implementation

	gui: EL_VISION2_USER_INTERFACE [FRACTAL_MAIN_WINDOW]

feature {NONE} -- Constants

	Option_name: STRING
		once
			Result := "fractal"
		end

	Description: STRING
		once
			Result := "Simple geometric fractal defined by Pyxis configuration file"
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{FRACTAL_APP}, All_routines],
				[{FRACTAL_MAIN_WINDOW}, All_routines]
			>>
		end

end
