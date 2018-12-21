note
	description: "Shared instance of [$source EL_USEABLE_SCREEN_IMP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-12 9:16:48 GMT (Monday 12th March 2018)"
	revision: "1"

class
	EL_SHARED_USEABLE_SCREEN

feature {NONE} -- Constants

	Useable_screen: EL_USEABLE_SCREEN_I
			-- For Unix systems this has to be called before any Vision2 GUI code
			-- This code is effectively a mini GTK app that determines the useable screen space
		once ("PROCESS")
			create {EL_USEABLE_SCREEN_IMP} Result.make
		end
end
