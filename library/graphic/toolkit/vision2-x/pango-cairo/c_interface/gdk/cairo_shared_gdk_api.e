note
	description: "Shared instance of class conforming to [$source CAIRO_GDK_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "11"

deferred class
	CAIRO_SHARED_GDK_API

inherit
	EL_ANY_SHARED

feature -- Access

	Gdk: CAIRO_GDK_I
		once
			create {CAIRO_GDK_API} Result.make
		end
end