note
	description: "Sequence objects in Python"
	author: "Daniel Rodriguez"
	date: "$Date$"
	file: "$Workfile: $"
	revision: "$Revision$"

deferred class
	PYTHON_SEQUENCE

inherit
	PYTHON_OBJECT

feature -- Access

	item_at (i: INTEGER): PYTHON_OBJECT
			-- Element at index `i'
		local
			p: POINTER
		do
			p := c_py_sequence_get_item (py_obj_ptr, i)
			if p = default_pointer then
				raise (Py_index_error)
			else
				Result := borrowed_python_object (p)
			end
		end
		
feature -- Status setting

	set_item_at (index: INTEGER; obj: PYTHON_OBJECT)
			-- Set object `obj' at `index' position.
		require
			obj_not_void: obj /= Void
			valid_index: index >= 0 and index < size
		local
			st: INTEGER
		do
			st := c_py_sequence_set_item (py_obj_ptr, index, obj.py_obj_ptr)
			if st = -1 then
				raise (Py_index_error)
			end
		end
		
feature -- Status report

	has (o: PYTHON_OBJECT): BOOLEAN
			-- Is `o' in `Current'?
		local
			r: INTEGER
		do
			r := c_py_sequence_contains (py_obj_ptr, o.py_obj_ptr)
			Result := r = 1
		end
		

feature -- Measurement

	size: INTEGER
			-- Elements count
		deferred
		end

end -- class PYTHON_SEQUENCE
