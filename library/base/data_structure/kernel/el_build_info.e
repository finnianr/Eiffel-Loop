note
	description: "Summary description for {EL_BUILD_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

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