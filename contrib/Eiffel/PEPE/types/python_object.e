note
	description: "General Python objects"
	author: "Daniel Rodriguez"
	date: "$Date:$"
	file: "$Workfile:$"
	revision: "$Revision:$"

class
	PYTHON_OBJECT
inherit
	COMPARABLE
		select
			is_equal
		end
	HASHABLE
		rename
			is_equal as is_equal_hash
		end
	MEMORY
		rename
			is_equal as mem_is_equal
		redefine
			dispose
		end
	PYTHON_API
		rename
			is_equal as is_equal_api
		end
		
create 
	new,
	borrowed

feature -- Initialization

	new (py: POINTER)
			-- Initialize `Current' as a python object owned by Eiffel.
			-- It will be DECREF-ed by disposal
		require
			p_not_null: py /= default_pointer
		do
			init (py)
			decreference := True
		end
		
	borrowed (py: POINTER)
			-- Initialize `Current' as a python object owned by Python.
			-- Not need to be DEREF-ed by disposal
		require
			p_not_null: py /= default_pointer
		do
			init (py)
		end
		
	init (py:POINTER)
			-- Initialize `Current' as the Python object with handle `py'.
		require
			right_type: py_obj_ptr /= default_pointer implies py_type_ptr = type_ptr_of_object_ptr (py)
		do
			py_obj_ptr := py
		end

feature -- Access

	py_obj_ptr: POINTER
			-- C-pointer to the handle for this Python object
	
	py_type_ptr: POINTER
			-- C-handle to the python type of this Python object
		do
			Result := c_py_object_type (py_obj_ptr)
		end
		
	python_type: PYTHON_TYPE
			-- Type object
		do
			create Result.borrowed (py_type_ptr)
		end	

	attribute_value (a: STRING): PYTHON_OBJECT
			-- Value of attribute named ` a'.
		require
			a_not_void: a/= Void
			a_exists: has_attribute (a)
		do
			Result := borrowed_python_object (c_py_object_get_attribute_string (py_obj_ptr, s2p (a)))
		end
	
	str: STRING
			-- External string representation of `Current' as a Python object
		local
			o: PYTHON_STRING
		do
			create o.new (c_py_object_repr (py_obj_ptr))
			Result := o.string
		end

	printable_out: STRING
			-- External string representation of `Current' as it would be called by str () or print in Python 
		local
			o: PYTHON_STRING
		do
			create o.new (c_py_object_str (py_obj_ptr))
			Result := o.string
		end
		
	unicode_out: PYTHON_USTRING
			-- Unicode string representation of `Current' as it would be called by unicodestr () in Python 
		do
			create Result.new (c_py_object_unicode (py_obj_ptr))
		end
		
	hash_code: INTEGER
			-- Hash code of `Current'
		do
			Result := c_py_object_hash (py_obj_ptr)
		end
		
feature -- Status settings

	set_attribute_value (a: STRING; v: PYTHON_OBJECT)
			-- Set value of attribute ` a' to `v'.
		require
			a_not_void: a /= Void
		do
			
		ensure
			attribute_set: has_attribute (a)
			right_value: v.is_equal (attribute_value (a))
		end
		
feature -- Element change

	delete_attribute (a: STRING)
			-- Delete attribute ` a'.
		require
			a_not_Void: a /= Void
			attribute_exists: has_attribute (a) 
		do
			
		ensure
			attribute_unset: not has_attribute (a)
		end
		
feature -- Conversion

	to_eiffel_type: ANY
			-- Returns a pure Eiffel type representation
		do			
		end
		
	
feature -- Status report

	decreference: BOOLEAN
			-- Does `Current' represent a "borrowed" object from PYTHON?
			-- not borrowed object must be DECREF-ed on disposing.
			
	has_attribute (a: STRING): BOOLEAN
			-- Is ` a' an attribute of `Current' as a PYTHON class?
		require
			a_not_void: a /= Void
		do
			
		end
		
	infix "<" (other: PYTHON_OBJECT): BOOLEAN
			-- Is `Current' < ` other' in the sense of PYTHON comparison?
		local
			r: INTEGER
		do
			r := c_py_object_compare (py_obj_ptr,other.py_obj_ptr)
			Result := r < 0
		end
		
	is_instance_of (t:PYTHON_TYPE): BOOLEAN
			-- Is `Current' a instance of Python type `t'?
		require
			t_not_void: t /= Void
		do
			
		end
	
	is_subclass_of (c: PYTHON_CLASS): BOOLEAN
			-- Is `Current''s generating Python class a subclass ocf `c'?
		require
			c_not_void: c /= Void
		do
			
		end
	
	is_subtype_of (t: PYTHON_TYPE)
			-- Is `Current' of type `t' or a subtype?
		require
			t_not_void: t /= Void
		do
			
		end
		
		
	is_callable: BOOLEAN
			-- Is `Current' a callable object in the sense of Python?
		do
			
		end
		
	is_dictionary: BOOLEAN
			-- Is `Current' a Python dictionary object?
		do
			Result := c_py_dict_check (py_obj_ptr) = 1
		end

	is_sequence: BOOLEAN
			-- Is `Current' a Python sequence object?
		do
			Result := c_py_sequence_check (py_obj_ptr) = 1
		end

	is_string: BOOLEAN
			-- Is `Current' a Python string object?
		do
			Result := c_py_string_check (py_obj_ptr) = 1
		end

	is_integer: BOOLEAN
			-- Is `Current' a Python integer object?
		do
			Result := c_py_int_check (py_obj_ptr) = 1
		end

	is_list: BOOLEAN
			-- Is `Current' a Python list object?
		do
			Result := c_py_list_check (py_obj_ptr) = 1
		end

	is_tuple: BOOLEAN
			-- Is `Current' a Python tuple object?
		do
			Result := c_py_tuple_check (py_obj_ptr) = 1
		end
		
feature {NONE} -- Implementation

	dispose
			-- 
		do
			if decreference then
				c_py_decref (py_obj_ptr)
			end
		end
		

invariant
	handle_set: py_obj_ptr /= default_pointer
	right_type: py_type_ptr = c_py_object_type (py_obj_ptr)

end -- class PYTHON_OBJECT
