note
	description: "[
		Interface to the class `BUILD_INFO' auto-generated by the Eiffel-Loop Scons build system.
		Accessible via [$source EL_MODULE_BUILD_INFO]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-04 9:05:38 GMT (Friday 4th October 2019)"
	revision: "8"

deferred class
	EL_BUILD_INFO

inherit
	ANY
		redefine
			default_create
		end

	EL_SHARED_SINGLETONS

feature {NONE} -- Initialization

	default_create
		do
			put_singleton (Current)
		end

feature -- Access

	installation_sub_directory: EL_DIR_PATH
			--
		deferred
		end

	version: EL_SOFTWARE_VERSION
			--
		do
			create Result.make (version_number, build_number)
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
