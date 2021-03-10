note
	description: "Java routine"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 15:46:24 GMT (Wednesday 10th March 2021)"
	revision: "5"

deferred class
	JAVA_ROUTINE

inherit
	JAVA_SHARED_ORB

	EL_MEMORY

	EL_MODULE_LIO

	EL_MODULE_EIFFEL

	EL_ROUTINE_INFO_FACTORY

feature {NONE} -- Initialization

	make (a_method_name: STRING; mapped_routine: ROUTINE)
			--
		require
			target_closed: mapped_routine.is_target_closed
			valid_target: attached {JAVA_OBJECT_REFERENCE} mapped_routine.target
		local
			routine_info: like new_routine_info
		do
			method_name := a_method_name
			create java_args.make (mapped_routine.open_count)
			if attached {JAVA_OBJECT_REFERENCE} mapped_routine.target as target then
				routine_info := new_routine_info (method_name, mapped_routine)
				set_method_id (target, routine_info.argument_types)
			end
		end

feature -- Access

	method_name: STRING

feature -- Status report

	valid_operands (args: TUPLE): BOOLEAN
			-- All operands conform to JAVA_TYPE
		local
			actual_type, i: INTEGER
		do
			Result := True
			from i := 1 until not Result or else i > args.count loop
				actual_type := {ISE_RUNTIME}.dynamic_type (args.item (i))
				if not {ISE_RUNTIME}.type_conforms_to (actual_type, Java_type_id) then
					Result := false
				end
				i := i + 1
			end
		end

	valid_target (target: JAVA_OBJECT_REFERENCE): BOOLEAN
			--
		do
			Result := target.is_attached_to_java_object
		end

feature {NONE} -- Implementation

	set_method_id (target: JAVA_OBJECT_REFERENCE; argument_types: EL_TUPLE_TYPE_ARRAY)
			--
		do
			method_id := target.method_id (method_name, method_signature (argument_types))
		ensure
			method_id_set: is_attached (method_id)
		end

	method_signature (argument_types: EL_TUPLE_TYPE_ARRAY): STRING
		 -- for some strange reason this causes a problem with Java object reclamation
		 -- even though the results are identical to `method_signature'
		 -- maybe something to do with somehow keeping a reference to the target
		local
			i: INTEGER; type_id: INTEGER; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			Result := buffer.copied ("(")
			from i := 1 until i > argument_types.count loop
				type_id := argument_types.item (i).type_id
				if attached Java_type_factory.new_item_from_type_id (type_id) as j_type then
					if attached {J_OBJECT_ARRAY [JAVA_OBJECT_REFERENCE]} j_type as array_type then
						array_type.default_create
					end
					Result.append_string (j_type.Jni_type_signature)
				end
				i := i + 1
			end
			Result.append_character (')')
			Result.append_string (return_type_signature)
			Result := Result.twin
		end

	return_type_signature: STRING
			-- Routines return type void
		deferred
		end

feature {NONE} -- Internal attributes

	method_id: POINTER

	java_args: JAVA_ARGUMENTS

feature {NONE} -- Constants

	Java_type_factory: EL_OBJECT_FACTORY [JAVA_TYPE]
		once
			create Result
		end

	Java_type_id: INTEGER
		once
			Result := ({JAVA_TYPE}).type_id
		end
end