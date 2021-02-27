note
	description: "Access to shared descendant of [$source EL_BUILD_INFO]"
	notes: "[
		Somewhere at the start of your application you need to create an instance of
		and object that inherits [$source EL_BUILD_INFO]
		If you use [$source EL_MULTI_APPLICATION_ROOT]  `[EL_BUILD_INFO, TUPLE]' to implement your root class, this
		will done for you automatically. A class `BUILD_INFO' is automatically generated
		by the Eiffel-Loop scons build system.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-27 16:48:34 GMT (Saturday 27th February 2021)"
	revision: "12"

deferred class
	EL_MODULE_BUILD_INFO

inherit
	EL_MODULE

feature {NONE} -- Constants

	Build_info: EL_BUILD_INFO
			--
		once
			Result := create {EL_CONFORMING_SINGLETON [EL_BUILD_INFO]}
		end
end