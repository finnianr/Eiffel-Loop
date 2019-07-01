note
	description: "Module java packages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:10:33 GMT (Monday 12th November 2018)"
	revision: "6"

deferred class
	EL_MODULE_JAVA_PACKAGES

inherit
	EL_MODULE

feature {NONE} -- Constants

	Java_packages: JAVA_PACKAGE_ENVIRONMENT_I
			--
		once
			create {JAVA_PACKAGE_ENVIRONMENT_IMP} Result.make
		end

end
