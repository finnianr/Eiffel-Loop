note
	description: "Shared access to instance of [$source CAIRO_GDK_API]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-30 14:55:19 GMT (Monday 30th May 2022)"
	revision: "9"

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