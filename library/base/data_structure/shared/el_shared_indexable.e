note
	description: "Shared indexable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 9:28:35 GMT (Sunday 20th April 2025)"
	revision: "1"

deferred class
	EL_SHARED_INDEXABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	indexable (container: READABLE_INDEXABLE [ANY]): EL_INDEXABLE_FROM_1_WRAPPER
		do
			Result := Once_indexable_wrapper
			Result.set_indexable (container)
		end

feature {NONE} -- Constants

	Once_indexable_wrapper: EL_INDEXABLE_FROM_1_WRAPPER
		once
			create Result
		end
end