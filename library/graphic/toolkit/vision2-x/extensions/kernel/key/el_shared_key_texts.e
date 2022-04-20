note
	description: "Shared KEY texts"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-20 5:18:45 GMT (Wednesday 20th April 2022)"
	revision: "1"

deferred class
	EL_SHARED_KEY_TEXTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Key_text: EL_KEY_TEXTS
		once
			create Result.make
		end
end