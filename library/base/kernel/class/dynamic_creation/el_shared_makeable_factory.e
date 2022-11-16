note
	description: "Shared access to factory of objects conforming to [$source EL_MAKEABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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