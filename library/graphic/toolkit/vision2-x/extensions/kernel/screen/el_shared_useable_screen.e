note
	description: "Shared instance of [$source EL_USEABLE_SCREEN_IMP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-23 16:04:24 GMT (Wednesday 23rd September 2020)"
	revision: "4"

deferred class
	EL_SHARED_USEABLE_SCREEN

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Useable_screen: EL_USEABLE_SCREEN_I
			-- For Unix systems this has to be called before any Vision2 GUI code
			-- This code is effectively a mini GTK app that determines the useable screen space
		local
			singleton: EL_SINGLETON [EL_USEABLE_SCREEN_IMP]
		once ("PROCESS")
			create singleton
			Result := singleton.item
		end
end