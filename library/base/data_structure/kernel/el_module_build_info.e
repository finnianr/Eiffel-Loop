note
	description: "Module build info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_MODULE_BUILD_INFO

inherit
	EL_MODULE

	EL_MODULE_EIFFEL

feature -- Access

	Build_info: EL_BUILD_INFO
			--
		local
			factory: EL_OBJECT_FACTORY [EL_BUILD_INFO]
		once
			create factory
			-- BUILD_INFO exists only in the application project
			Result := factory.instance_from_class_name ("BUILD_INFO", agent {EL_BUILD_INFO}.do_nothing)
		end
end