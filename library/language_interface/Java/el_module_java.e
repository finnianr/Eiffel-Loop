note
	description: "Module java packages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "10"

deferred class
	EL_MODULE_JAVA

inherit
	EL_MODULE

feature {NONE} -- Constants

	Java: JAVA_ENVIRONMENT
			--
		once ("PROCESS")
			create Result.make
		end

end