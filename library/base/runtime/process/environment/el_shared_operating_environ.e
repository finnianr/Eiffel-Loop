note
	description: "Shared access to routines of class [$source EL_OPERATING_ENVIRONMENT_I]"
	notes: "[
		Routine `Operating_environment' is found in class `ANY' so it is impractical to clash
		with this name, hence abbreviation to `Operating_environ'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "11"

deferred class
	EL_SHARED_OPERATING_ENVIRON

inherit
	EL_ANY_SHARED

feature {EL_MODULE_ENVIRONMENT} -- Constants

	Operating_environ: EL_OPERATING_ENVIRONMENT_I
			--
		once ("PROCESS")
			create {EL_OPERATING_ENVIRONMENT_IMP} Result
		end

end