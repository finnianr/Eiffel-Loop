note
	description: "Shared object pool"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_SHARED_OBJECT_POOL

feature {NONE} -- Implementation

	new_current_object (instance: ANY): REFLECTED_REFERENCE_OBJECT
		local
			pool: like Object_pool
		do
			pool := Object_pool
			if pool.is_empty then
				create Result.make (instance)
			else
				Result := pool.item
				Result.set_object (instance)
				pool.remove
			end
		end

	recycle (object: like new_current_object)
		do
			object.set_object (0)
			Object_pool.put (object)
		end

feature {NONE} -- Constants

	frozen Object_pool: ARRAYED_STACK [REFLECTED_REFERENCE_OBJECT]
		once
			create Result.make (3)
		end

end
