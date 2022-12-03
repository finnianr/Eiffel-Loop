note
	description: "Shared instance of object conforming to [$source TP_OPTIMIZED_FACTORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 16:39:40 GMT (Saturday 3rd December 2022)"
	revision: "5"

deferred class
	TP_SHARED_OPTIMIZED_FACTORY

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Factory_general: TP_OPTIMIZED_FACTORY
		once ("PROCESS")
			create Result
		end

	Factory_readable_string_8: TP_RSTRING_FACTORY
		once ("PROCESS")
			create Result
		end

	Factory_zstring: TP_ZSTRING_FACTORY
		once ("PROCESS")
			create Result
		end

end
