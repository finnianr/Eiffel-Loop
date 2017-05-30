note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-29 12:54:32 GMT (Monday 29th May 2017)"
	revision: "2"

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
				{QUANTUM_BALL_ANIMATION_APP},
				{POST_CARD_VIEWER_APP},
				{PANGO_CAIRO_TEST_APP}
			>>
		end

end
