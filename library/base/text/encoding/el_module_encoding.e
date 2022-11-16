note
	description: "Shared instance of class [$source EL_ENCODING]"
	notes: "Mostly used for contract suppor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	EL_MODULE_ENCODING

inherit
	EL_MODULE

feature {NONE} -- Constants

	Encoding: EL_ENCODING
		once
			create Result.make_default
		end

end