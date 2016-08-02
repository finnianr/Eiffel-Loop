note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-04 18:49:49 GMT (Friday 4th March 2016)"
	revision: "1"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Implementation

	Application_types: ARRAY [TYPE [EL_SUB_APPLICATION]]
			--
		once
			Result := <<
				{CONSOLE_LOGGING_QUANTUM_BALL_ANIMATION_APP},
				{QUANTUM_BALL_ANIMATION_APP},
				{POST_CARD_VIEWER_APP},
				{PANGO_CAIRO_TEST_APP}
			>>
		end

end