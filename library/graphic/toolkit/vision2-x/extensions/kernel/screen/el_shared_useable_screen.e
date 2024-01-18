note
	description: "Shared instance of ${EL_USEABLE_SCREEN_IMP}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

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