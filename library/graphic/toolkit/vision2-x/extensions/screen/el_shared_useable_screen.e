note
	description: "Shared instance of [$source EL_USEABLE_SCREEN_IMP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:24:46 GMT (Monday 1st July 2019)"
	revision: "3"

deferred class
	EL_SHARED_USEABLE_SCREEN

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Useable_screen: EL_USEABLE_SCREEN_I
			-- For Unix systems this has to be called before any Vision2 GUI code
			-- This code is effectively a mini GTK app that determines the useable screen space
		once ("PROCESS")
			create {EL_USEABLE_SCREEN_IMP} Result.make
		end
end
