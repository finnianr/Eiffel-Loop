note
	description: "Finalized executable tests for library [./library/i18n.html i18n.ecf]"
	notes: "[
		Command option: `-i18n_autotest'
		
		**Test Sets**
		
			[$source TRANSLATION_TABLE_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-18 21:52:18 GMT (Tuesday 18th January 2022)"
	revision: "65"

class
	I18N_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_SUB_APPLICATION [TRANSLATION_TABLE_TEST_SET]

create
	make

end