note
	description: "[
		Normalizes location of implementation classes `(*_imp.e)' in relation to respective interfaces
		`(*_i.e)' for all projects referenced in repository publishing configuration. See class
		[$source CROSS_PLATFORM_CLUSTER] for details.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-27 11:08:39 GMT (Thursday 27th December 2018)"
	revision: "3"

class
	IMP_CLASS_LOCATION_NORMALIZER

inherit
	REPOSITORY_PUBLISHER
		redefine
			execute, new_configuration_file
		end

create
	make

feature -- Basic operations

	execute
		do
			ecf_list.do_all (agent {like new_configuration_file}.normalize_imp_classes)
		end

feature {NONE} -- Factory

	new_configuration_file (ecf: ECF_INFO): CROSS_PLATFORM_EIFFEL_CONFIGURATION_FILE
		do
			create Result.make (Current, ecf)
		end

end
