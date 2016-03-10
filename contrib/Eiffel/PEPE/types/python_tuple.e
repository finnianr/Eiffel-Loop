note
	description: "Python object tuple represented in Eiffel"
	author: "Daniel Rodriguez"
	date: "$Date$"
	revision: "$Revision$"

class
	PYTHON_TUPLE

inherit
	PYTHON_SEQUENCE
		redefine
			py_type_ptr,
			item_at,
			set_item_at
		end

create
	borrowed,
	new

feature -- Access

	py_type_ptr: POINTER
			-- Pointer to the type object
		do
			Result := c_py_tuple_type
		end
		
	item_at (i: INTEGER): PYTHON_OBJECT
			-- Element at index `i'.
		local
			p: POINTER
		do
			p := c_py_tuple_get_item (py_obj_ptr, i)
			if p = default_pointer then
				raise (Py_index_error)
			else
				Result := borrowed_python_object (p)
			end
		end

feature -- Status setting

	set_item_at (index: INTEGER; obj: PYTHON_OBJECT)
			-- Set object `obj' at `index' position.
		local
			st: INTEGER
		do
			st := c_py_tuple_set_item (py_obj_ptr, index, obj.py_obj_ptr)
			if st = -1 then
				raise (Py_index_error)
			end
		end

feature -- Measurement

	size: INTEGER
			-- Element count
		do
			Result := c_py_tuple_size (py_obj_ptr)
		end

end -- class PYTHON_TUPLE
