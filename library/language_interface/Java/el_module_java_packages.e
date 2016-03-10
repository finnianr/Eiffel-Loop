note
	description: "Summary description for {EL_MODULE_JAVA_PACKAGES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2011-07-24 9:48:03 GMT (Sunday 24th July 2011)"
	revision: "1"

class
	EL_MODULE_JAVA_PACKAGES

inherit
	EL_MODULE

feature -- Acess

	Java_packages: JAVA_PACKAGE_ENVIRONMENT
			--
		once
			create Result.make
		end

end
