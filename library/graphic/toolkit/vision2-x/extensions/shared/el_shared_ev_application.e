note
	description: "Shared Vision-2 GUI application and environment objects"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 18:51:04 GMT (Monday 17th October 2022)"
	revision: "1"

deferred class
	EL_SHARED_EV_APPLICATION

inherit
	EL_ANY_SHARED

	EV_SHARED_APPLICATION
		export
			{NONE} all
		undefine
			copy, default_create, is_equal, out
		end
end