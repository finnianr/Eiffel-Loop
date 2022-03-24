note
	description: "Module java packages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-24 11:01:38 GMT (Thursday 24th March 2022)"
	revision: "9"

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