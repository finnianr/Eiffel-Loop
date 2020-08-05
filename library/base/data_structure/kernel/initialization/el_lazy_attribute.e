note
	description: "Detachable object attribute that is created only when needed"
	notes: "[
		This class is a workaround for bug in ES version 16.05.9 for the "once per object" construct
		
			object: MY_CLASS
				once ("OBJECT")
					create Result
				end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-04 11:04:32 GMT (Tuesday 4th August 2020)"
	revision: "2"

deferred class
	EL_LAZY_ATTRIBUTE

feature -- Access

	item: like new_item
		do
			if attached actual_item as obj then
				Result := obj
			else
				Result := new_item
				actual_item := Result
			end
		end

feature {NONE} -- Implementation

	new_item: ANY
		deferred
		end

	actual_item: detachable like new_item
end
