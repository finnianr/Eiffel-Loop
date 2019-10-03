note
	description: "Module build info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-03 11:00:30 GMT (Thursday   3rd   October   2019)"
	revision: "9"

deferred class
	EL_MODULE_BUILD_INFO

inherit
	EL_MODULE

	EL_MODULE_EIFFEL

feature {NONE} -- Constants

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
