note
	description: "Audio sample memory list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:05 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_AUDIO_SAMPLE_MEMORY_LIST

inherit
	EL_AUDIO_SAMPLE_LIST
	
feature {NONE} -- Implementation

	normalized_item: REAL
			-- 
		deferred
		end
	
	start
			-- 
		do
			create sample_ptr.share_from_pointer (data, data_size)
			index := 1
			index_max := sample_count
		end
		
	after: BOOLEAN
			-- 
		do
			Result := (index = index_max + 1)
		end
		
	sample_count: INTEGER
			-- 
		deferred
		end
		
	move (i: INTEGER)
			-- Move cursor `i' positions.
		do
			index := index + i
			if (index > index_max + 1) then
				index := index_max + 1
			end
		end
		
	index, index_max: INTEGER
	
	sample_ptr: MANAGED_POINTER
	
	data_size: INTEGER
			-- 
		deferred
		end
	
	data: POINTER		
			--
		deferred
		end
	
end