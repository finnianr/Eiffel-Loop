note
	description: "Date time testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-03 11:40:36 GMT (Sunday 3rd November 2024)"
	revision: "10"

class
	ISE_DATE_TIME_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
			>>)
		end

feature -- Tests

feature -- Basic operations

	make_date
		local
			date_1, date_2, date_3: DATE_TIME; date_iso: EL_SHORT_ISO_8601_DATE_TIME
		do
			create date_1.make_from_string ("20171216113300", "yyyy[0]mm[0]dd[0]hh[0]mi[0]ss")
			create date_2.make_from_string ("2017-12-16 11:33:00", "yyyy-[0]mm-[0]dd [0]hh:[0]mi:[0]ss") -- Fails
			create date_iso.make ("20171216T113300Z")
			create date_3.make_from_string ("19:35:01 Apr 09, 2016", "[0]hh:[0]mi:[0]ss Mmm [0]dd, yyyy")
		end

	time_parsing
		local
			time_str, l_format: STRING; time: TIME
			checker: TIME_VALIDITY_CHECKER
		do
			time_str := "21:15"; l_format := "hh:mi"
			create checker
			if True or checker.time_valid (time_str, l_format) then
				create time.make_from_string (time_str, l_format)
			else
				create time.make (0, 0, 0)
			end
			lio.put_labeled_string ("Time", time.formatted_out ("hh:[0]mi"))
			lio.put_new_line
		end

	validity_check
		local
			checker: DATE_VALIDITY_CHECKER; str: STRING
		do
			create checker
			str := "2015-12-50"
			lio.put_labeled_string (str, checker.date_valid (str, "yyyy-[0]mm-[0]dd").out)
		end

end