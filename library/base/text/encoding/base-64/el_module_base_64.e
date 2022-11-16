note
	description: "Shared access to instance of [$source EL_BASE_64_CODEC]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "13"

deferred class
	EL_MODULE_BASE_64

inherit
	EL_MODULE

feature {NONE} -- Constants

	Base_64: EL_BASE_64_CODEC
			--
		once
			create Result.make
		end

end