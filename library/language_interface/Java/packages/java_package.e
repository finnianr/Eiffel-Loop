note
	description: "Java package"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	JAVA_PACKAGE

inherit
	ANY
		undefine
			is_equal
		end

feature -- Access
	
	package_name: STRING
			-- 
		deferred
		end

end -- class JAVA_PACKAGE