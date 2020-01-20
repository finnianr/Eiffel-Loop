note
	description: "Shared access to factory of objects conforming to [$source EL_MAKEABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-20 21:20:34 GMT (Monday 20th January 2020)"
	revision: "1"

deferred class
	EL_SHARED_MAKEABLE_FACTORY

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Makeable_factory: EL_MAKEABLE_OBJECT_FACTORY
		once
			create Result
		end

end
