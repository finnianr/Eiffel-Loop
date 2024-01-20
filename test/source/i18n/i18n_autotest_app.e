note
	description: "Finalized executable tests for library [./library/i18n.html i18n.ecf]"
	notes: "[
		Command option: `-i18n_autotest'
		
		**Test Sets**
		
			${I18N_LOCALIZATION_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "73"

class
	I18N_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [I18N_LOCALIZATION_TEST_SET]
		undefine
			make_solitary
		end

	EL_LOCALIZED_APPLICATION

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [EL_LOCALE]
		do
			create Result
		end

end