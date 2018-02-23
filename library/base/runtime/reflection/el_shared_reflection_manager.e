note
	description: "[
		Use this to register types conforming to [$source EL_MAKEABLE_FROM_STRING] for use as fields in
		classes conforming to [$source EL_REFLECTIVE]. The once index should be "PROCESS".
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-22 16:48:27 GMT (Monday 22nd January 2018)"
	revision: "2"

deferred class
	EL_SHARED_REFLECTION_MANAGER

feature {NONE} -- Constants

	Reflection_manager: EL_REFLECTION_MANAGER
		once ("PROCESS")
			create Result.make
		end

feature {NONE} -- Initialization

	initialize_reflection
		-- register types in `Reflection_manager' that implement `EL_MAKEABLE_FROM_STRING'
		-- or `EL_MAKEABLE'
		deferred
		end

	initialize_nothing
		do
		end

end

