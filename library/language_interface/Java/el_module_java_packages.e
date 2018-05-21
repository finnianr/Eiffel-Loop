note
	description: "Module java packages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_MODULE_JAVA_PACKAGES

inherit
	EL_MODULE

feature -- Acess

	Java_packages: JAVA_PACKAGE_ENVIRONMENT_I
			--
		once
			create {JAVA_PACKAGE_ENVIRONMENT_IMP} Result.make
		end

end