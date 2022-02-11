note
	description: "Shared instance of class [$source EL_ENCODING]"
	notes: "Mostly used for contract suppor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-11 9:21:54 GMT (Friday 11th February 2022)"
	revision: "4"

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