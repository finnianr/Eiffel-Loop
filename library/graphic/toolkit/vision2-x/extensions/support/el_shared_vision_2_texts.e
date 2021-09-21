note
	description: "Shared instance of [$source EL_VISION_2_TEXTS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-20 14:47:50 GMT (Monday 20th September 2021)"
	revision: "1"

deferred class
	EL_SHARED_VISION_2_TEXTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Text: EL_VISION_2_TEXTS
		once
			create Result.make
		end
end