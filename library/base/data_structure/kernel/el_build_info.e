note
	description: "[
		Interface to the class `BUILD_INFO' auto-generated by Scons build.
		Accessible via [$source EL_MODULE_BUILD_INFO]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "5"

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
