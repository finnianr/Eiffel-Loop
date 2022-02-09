note
	description: "Shared instance of class [$source EL_SYSTEM_ENCODINGS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-09 11:26:03 GMT (Wednesday 9th February 2022)"
	revision: "3"

deferred class
	EL_MODULE_ENCODING

inherit
	EL_MODULE

feature {NONE} -- Constants

	Encoding: ENCODING_I
		once
			create {ENCODING_IMP} Result
		end

end