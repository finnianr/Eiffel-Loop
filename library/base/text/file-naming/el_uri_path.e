note
	description: "Summary description for {EL_URI_PATH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 18:28:31 GMT (Wednesday 16th December 2015)"
	revision: "1"

deferred class
	EL_URI_PATH

inherit
	EL_PATH
		redefine
			default_create, make, make_from_other, to_string, Type_parent, hash_code,
			is_uri, is_path_absolute, is_equal, is_less, Separator
		end

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			domain := Empty_path
			protocol := Empty_path
		end

feature -- Initialization

	make (a_path: ZSTRING)
		require else
			is_absolute: a_path.has_substring (Protocol_sign)
					implies a_path.index_of ('/', a_path.substring_index (Protocol_sign, 1) + 3) > 0

			is_absolute_file: a_path.starts_with (File_protocol_sign)
					implies (a_path.count > File_protocol_sign.count
					and then a_path.unicode_item (File_protocol_sign.count) = Unix_separator)

			implicit_path_is_absolute: not a_path.has_substring (Protocol_sign)
					implies (a_path.count > 1 and then a_path.unicode_item (1) = Unix_separator)
		local
			pos_protocol_sign, pos_first_slash: INTEGER
			l_domain, l_protocol: ZSTRING
		do
			pos_protocol_sign := a_path.substring_index (Protocol_sign, 1)
			if pos_protocol_sign > 0 then
				pos_first_slash := a_path.index_of ('/', pos_protocol_sign + 3)
				l_protocol := a_path.substring (1, pos_protocol_sign - 1)
				l_domain := a_path.substring (pos_protocol_sign + 3, pos_first_slash - 1)
				Precursor (a_path.substring (pos_first_slash, a_path.count))
			else
				l_domain := Empty_path
				l_protocol := once "file"
				Precursor (a_path)
			end
			protocol := l_protocol
			domain := l_domain
		ensure then
			is_absolute: is_absolute
		end

	make_from_other (other: EL_URI_PATH)
		do
			Precursor (other)
			domain := other.domain.twin
			protocol := other.protocol.twin
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		do
			Result := internal_hash_code
			if Result = 0 then
				Result := combined_hash_code (<< protocol, domain, parent_path, base >>)
				internal_hash_code := Result
			end
		end

	domain: ZSTRING

	protocol: ZSTRING

feature -- Status query

	is_uri: BOOLEAN
		do
			Result := True
		end

feature -- Conversion

	 to_string: ZSTRING
	 	local
	 		l_path: ZSTRING
	 	do
	 		l_path := Precursor
	 		create Result.make (protocol.count + 3 + domain.count + l_path.count)
	 		Result.append (protocol + Protocol_sign + domain + l_path)
	 	end

	 to_encoded_utf_8: EL_URL_STRING
	 	do
	 		create Result.make_empty
	 		Result.enable_space_escaping
	 		Result.append_utf_8 (to_string.to_utf_8)
	 	end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			--
		do
			Result := Precursor (other) and then protocol ~ other.protocol and then domain ~ other.domain
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if protocol ~ other.protocol then
				if domain ~ other.domain then
					Result := Precursor (other)
				else
					Result := domain < other.domain
				end
			else
				Result := protocol < other.protocol
			end
		end

feature -- Contract Support

	is_path_absolute (a_path: ZSTRING): BOOLEAN
		do
			Result := not a_path.is_empty and then a_path [1] = Separator
		end

feature {NONE} -- Type definitions

	Type_parent: EL_DIR_URI_PATH
		once
		end

feature -- Constants

	Separator: CHARACTER_32
		once
			Result := Unix_separator
		end

	Protocol_sign: ZSTRING
		once
			Result := "://"
		end

	File_protocol_sign: ZSTRING
		once
			Result := "file://"
		end
end