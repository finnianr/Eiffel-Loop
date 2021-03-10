note
	description: "Module java packages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 9:32:28 GMT (Wednesday 10th March 2021)"
	revision: "8"

deferred class
	EL_MODULE_JAVA

inherit
	EL_MODULE

feature {NONE} -- Constants

	Java: JAVA_ENVIRONMENT_I
			--
		once ("PROCESS")
			create {JAVA_ENVIRONMENT_IMP} Result.make
		end

end