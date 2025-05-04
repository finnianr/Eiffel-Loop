note
	description: "Shared instance of ${DEVELOPMENT_ENVIRONMENT}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 20:39:45 GMT (Sunday 4th May 2025)"
	revision: "5"

deferred class
	SHARED_DEV_ENVIRON

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	eiffel_loop_dir: DIR_PATH
		do
			Result := Dev_environ.Eiffel_loop_dir
		end

feature {NONE} -- Constants

	Dev_environ: DEVELOPMENT_ENVIRONMENT
		once
			create Result
		end
end