note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-20 13:07:19 GMT (Monday 20th May 2019)"
	revision: "4"

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
				{FRACTAL_APP},

				{POST_CARD_VIEWER_APP},
				{PANGO_CAIRO_TEST_APP},
				
				{QUANTUM_BALL_ANIMATION_APP}
			>>
		end

end
