note
	description: "Summary description for {EL_MODULE_JAVA_PACKAGES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-22 15:24:09 GMT (Wednesday 22nd June 2016)"
	revision: "4"

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
