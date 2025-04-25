note
	description: "[
		Map names to a performance benchmark which could be either a "number of passes" benchmark or
		a memory benchmark.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 10:01:19 GMT (Friday 25th April 2025)"
	revision: "1"

class
	EL_NAMED_BENCHMARK_MAP_LIST

inherit
	EL_ARRAYED_MAP_LIST [ZSTRING, NATURAL_64]
		rename
			item_key as item_name,
			key_list as name_list
		end

	EL_DOUBLE_MATH_I

	EL_CHARACTER_32_CONSTANTS

	EL_SHARED_FORMAT_FACTORY

create
	make

feature -- Basic operations

	print_comparison (lio: EL_LOGGABLE; a_template_relative: READABLE_STRING_GENERAL)
		-- print benchmarks comparison is descending order with relative proportions to maximum using
		-- template `a_template_relative'. (For example "%S times (%S)").
		require
			valid_template: a_template_relative.occurrences ('%S') = 2
		local
			description_width: INTEGER; highest_count: NATURAL_64; relative_difference: DOUBLE
			l_label, formatted_value, relative_percentile: STRING; l_double: FORMAT_DOUBLE
			template_relative: ZSTRING
		do
			create template_relative.make_from_general (a_template_relative)
			sort_by_value (False)
			description_width := name_list.max_integer (agent {ZSTRING}.count)
			highest_count := first_value
			create l_double.make (log10 (highest_count).rounded + 3, 1)

			from start until after loop
				l_label := item_name + space * (description_width - item_name.count + 1)
				formatted_value := l_double.formatted (item_value)
				if isfirst then
					relative_percentile := once "100%%"
				else
					relative_difference := ((highest_count - item_value) / highest_count) * 100
					relative_percentile := Format.double_as_string (relative_difference, once "999.9%%")
					relative_percentile.prepend_character ('-')
				end
				lio.put_labeled_string (l_label, template_relative #$ [formatted_value, relative_percentile])
				lio.put_new_line
				forth
			end
		end
end