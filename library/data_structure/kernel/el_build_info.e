note
	description: "Summary description for {EL_BUILD_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:23:50 GMT (Tuesday 18th June 2013)"
	revision: "3"

deferred class
	EL_BUILD_INFO

feature -- Access

	version: EL_SOFTWARE_VERSION
			--
		do
			create Result.make (version_number, build_number)
		end

	installation_sub_directory: EL_DIR_PATH
			--
		deferred
		end

feature -- Measurement

	build_number: NATURAL
			--
		deferred
		end

	version_number: NATURAL
			-- version in form jj_nn_tt where: jj is major version, nn is minor version and tt is maintenance version
			-- padded with leading zeros: eg. 01_02_15 is Version 1.2.15
		deferred
		end

end
