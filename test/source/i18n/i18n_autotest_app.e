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
	date: "2022-03-12 17:09:29 GMT (Saturday 12th March 2022)"
	revision: "69"

class
	I18N_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [TRANSLATION_TABLE_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [EL_LOCALE]
		do
			create Result
		end

end