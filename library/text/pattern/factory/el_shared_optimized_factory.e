note
	description: "Shared instance of object conforming to [$source EL_OPTIMIZED_PATTERN_FACTORY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 8:48:21 GMT (Monday 14th November 2022)"
	revision: "1"

deferred class
	EL_SHARED_OPTIMIZED_FACTORY

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	core: EL_OPTIMIZED_PATTERN_FACTORY
		do
			Result := Optimized_list.item
		end

	set_optimal_core (text: READABLE_STRING_GENERAL)
		-- set `optimal_core' factory with shared instance that is optimal for `text' type
		do
			if attached {ZSTRING} text then
				Optimized_list.go_i_th (3)

			elseif attached {READABLE_STRING_8} text then
				Optimized_list.go_i_th (2)

			else
				Optimized_list.go_i_th (1)
			end
		end

feature {NONE} -- Constants

	Optimized_list: ARRAYED_LIST [EL_OPTIMIZED_PATTERN_FACTORY]
		once
			create Result.make_from_array (<<
				create {EL_OPTIMIZED_PATTERN_FACTORY},
				create {EL_STRING_8_PATTERN_FACTORY},
				create {EL_ZSTRING_PATTERN_FACTORY}
			>>)
		end

end