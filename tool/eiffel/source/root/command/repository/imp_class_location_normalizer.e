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
	date: "2022-06-04 12:45:19 GMT (Saturday 4th June 2022)"
	revision: "7"

class
	IMP_CLASS_LOCATION_NORMALIZER

inherit
	REPOSITORY_PUBLISHER
		redefine
			execute, ecf_list
		end

	EL_APPLICATION_COMMAND

create
	make

feature -- Access

	Description: STRING = "Normalizes location of implementation classes in relation to respective interfaces"

	ecf_list: EIFFEL_CONFIGURATION_LIST [CROSS_PLATFORM_EIFFEL_CONFIGURATION_FILE]

feature -- Basic operations

	execute
		do
			ecf_list.do_all (agent {CROSS_PLATFORM_EIFFEL_CONFIGURATION_FILE}.normalize_imp_classes)
		end

end