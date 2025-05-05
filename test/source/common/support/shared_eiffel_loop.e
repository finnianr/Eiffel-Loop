note
	description: "Shared instance of ${DEVELOPMENT_ENVIRONMENT}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 9:28:42 GMT (Monday 5th May 2025)"
	revision: "6"

deferred class
	SHARED_EIFFEL_LOOP

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	eiffel_loop_dir: DIR_PATH
		do
			Result := Eiffel_loop.home_dir
		end

feature {NONE} -- Constants

	Eiffel_loop: EIFFEL_LOOP_ENVIRONMENT
		once
			create Result
		end
end