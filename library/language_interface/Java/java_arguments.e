note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2011-07-24 9:48:03 GMT (Sunday 24th July 2011)"
	revision: "1"

class
	JAVA_ARGUMENTS

inherit
	JAVA_ARGS
		rename
			make as make_obsolete
		export
			{NONE} all
			{ANY} to_c, count
		redefine
			to_c
		end

create
	make

feature {NONE} -- Initialization

	make (nb: INTEGER)
			-- Make an argument list for at most `nb' arguments.
		do
			count := nb
			create jvalue.make
			create java_args_array.make (jvalue.structure_size * nb)
		end

feature -- Element change

	put_java_tuple (args: TUPLE)
			--
		require
			tuple_is_right_size: args.count = count
			valid_operands: valid_operands (args)
		local
			i: INTEGER
		do
			make (args.count)
			from i := 1 until i > args.count loop
				if attached {JAVA_TYPE} args.item (i) as arg_item then
					jvalue.make_by_pointer (java_args_array.item + (i - 1) * sizeof_jvalue)
					arg_item.set_argument (jvalue)
				end
				i := i + 1
			end
		end

feature -- Access

	to_c: POINTER
			--
		do
			if count > 0 then
				Result := java_args_array.item
			end
		end

feature -- Status report

	valid_operands (args: TUPLE): BOOLEAN

		local
			i: INTEGER
		do
			Result := true
			from i := 1 until i > args.count or Result = false loop
				Result := attached {JAVA_TYPE} args.item (i) as arg_item
				i := i + 1
			end
		end

end -- class JAVA_ARGUMENTS
