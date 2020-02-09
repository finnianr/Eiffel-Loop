note
	description: "Autotest class [$source EL_SVG_IMAGE_UTILS] from `image-utils.ecf'"
	notes: "Command option: `-image_utils_autotest'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-09 10:39:20 GMT (Sunday 9th February 2020)"
	revision: "5"

class
	IMAGE_UTILS_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION
		redefine
			log_filter
		end

create
	make

feature {NONE} -- Implementation

	evaluator_type: TUPLE [IMAGE_UTILS_TEST_EVALUATOR]
		do
			create Result
		end

	evaluator_types_all: TUPLE [
		IMAGE_UTILS_TEST_EVALUATOR
	]
		do
			create Result
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines],
				[{IMAGE_UTILS_TEST_SET}, All_routines]
			>>
		end

end
