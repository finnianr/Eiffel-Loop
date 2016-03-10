note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-02-13 13:06:38 GMT (Wednesday 13th February 2013)"
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
				{CONSOLE_LOGGING_QUANTUM_BALL_ANIMATION_APP},
				{DOCKING_APP},
				{QUANTUM_BALL_ANIMATION_APP},
				{POST_CARD_VIEWER_APP}
			>>
		end

end
