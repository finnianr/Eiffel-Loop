note
	description: "Root class for Java packages"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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

end