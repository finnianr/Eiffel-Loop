note
	description: "Access to shared instance of [$source MEMORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_MODULE_MEMORY

inherit
	EL_MODULE

feature {NONE} -- Constants

	Memory: MEMORY
		once
			create Result
		end

end