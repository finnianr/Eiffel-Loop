note
	description: "Object attribute that is created only if it is needed"
	notes: "[
		This is a duplicate of [$source EL_LAZY_ATTRIBUTE] for use in the case of an inheritance conflict.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-03 14:03:29 GMT (Monday 3rd August 2020)"
	revision: "1"

deferred class
	EL_LAZY_ATTRIBUTE_2

feature -- Access

	object: like new_object
		do
			if attached actual_object_2 as obj then
				Result := obj
			else
				Result := new_object
				actual_object_2 := Result
			end
		end

feature {NONE} -- Implementation

	new_object: ANY
		deferred
		end

	actual_object_2: detachable like new_object
		-- actual created instance
		-- typically this is not renamed in descendant so suffixed with `_2'
		-- to prevent name clash with `{EL_LAZY_ATTRIBUTE}.actual_object'
end
