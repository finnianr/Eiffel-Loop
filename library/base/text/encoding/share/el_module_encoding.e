note
	description: "Shared instance of class ${EL_ENCODING}"
	notes: "Mostly used for contract suppor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "6"

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