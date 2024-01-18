note
	description: "Shared instance of ${EL_PAPER_DIMENSIONS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-07 20:17:48 GMT (Friday 7th July 2023)"
	revision: "2"

deferred class
	EL_SHARED_PAPER_DIMENSIONS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Paper: EL_PAPER_DIMENSIONS
		once
			create Result.make_best_fit
		end
end