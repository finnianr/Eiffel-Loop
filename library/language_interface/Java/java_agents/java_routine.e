note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-18 10:24:27 GMT (Tuesday 18th December 2012)"
	revision: "1"

deferred class
	JAVA_ROUTINE [BASE_TYPE -> JAVA_OBJECT_REFERENCE]

inherit
	JAVA_SHARED_ORB

	EL_MEMORY

	EL_MODULE_LOG

	EL_MODULE_TYPING

feature {NONE} -- Initialization

	make (method_name: STRING; mapped_routine: ROUTINE [BASE_TYPE, TUPLE])
			--
		do
			create java_args.make (mapped_routine.open_count)
			set_method_id (method_name, mapped_routine)
		end

feature -- Status report

	valid_operands (args: TUPLE): BOOLEAN
			-- All operands conform to JAVA_TYPE
		local
			expected_type, actual_type, i: INTEGER
			type_checker: INTERNAL
		do
			Result := true
			create type_checker
			from i := 1 until i > args.count or Result = false
			loop
				expected_type := type_checker.dynamic_type_from_string ("JAVA_TYPE")
				actual_type := type_checker.dynamic_type (args.item (i))

				if not type_checker.type_conforms_to (actual_type, expected_type) then
					Result := false
				end
				i := i + 1
			end
		end

	valid_target (target: BASE_TYPE): BOOLEAN
			--
		do
			Result := target.is_attached_to_java_object
		end

feature {NONE} -- Implementation

	set_method_id (method_name: STRING; mapped_routine: ROUTINE [BASE_TYPE, TUPLE])
			--
		do
			if attached {BASE_TYPE} mapped_routine.target as target then
				method_id := target.method_id (method_name, method_signature (mapped_routine.empty_operands))
			end
		ensure
			method_id_set: is_attached (method_id)
		end

	method_signature (empty_operands: TUPLE): STRING
			--
		local
			i: INTEGER
			class_id: INTEGER
		do
			create Result.make_from_string ("(")
			from i := 1 until i > empty_operands.count loop
				class_id := Typing.generic_dynamic_type (empty_operands, i)
				if attached {JAVA_TYPE} Typing.new_instance_of (class_id) as type then
					if attached {J_OBJECT_ARRAY [JAVA_OBJECT_REFERENCE]} type as array_type then
						array_type.default_create
					end
					Result.append_string (type.Jni_type_signature)
				end
				i := i + 1
			end
			Result.append_character (')')
			Result.append_string ( return_type_signature )
		end

	method_id: POINTER

	return_type_signature: STRING
			-- Routines return type void
		deferred
		end

	java_args: JAVA_ARGUMENTS

end -- class JAVA_ROUTINE
