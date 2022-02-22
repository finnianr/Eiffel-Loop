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
	date: "2022-02-22 17:35:33 GMT (Tuesday 22nd February 2022)"
	revision: "68"

class
	I18N_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [TRANSLATION_TABLE_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [EL_LOCALE_IMP]
		do
			create Result
		end

end