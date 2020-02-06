note
	description: "VTD-XML autotest app"
	notes: "Option: `-vtd_xml_autotest'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 15:03:08 GMT (Thursday 6th February 2020)"
	revision: "4"

class
	VTD_XML_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION
		redefine
			log_filter
		end

create
	make

feature {NONE} -- Implementation

	evaluator_type: TUPLE [XML_TO_PYXIS_CONVERTER_TEST_EVALUATOR]
		do
			create Result
		end

	evaluator_types_all: TUPLE [
		VTD_XML_TEST_EVALUATOR,
		XML_TO_PYXIS_CONVERTER_TEST_EVALUATOR
	]
		do
			create Result
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{VTD_XML_TEST_SET}, All_routines],
				[{XML_TO_PYXIS_CONVERTER_TEST_SET}, All_routines]
			>>
		end

end
