note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MATLAB_MATH

feature -- Basic operations

	n_point_discrete_fourier_transform (
		column_vector: EL_COLUMN_VECTOR_DOUBLE; num_points: INTEGER

	): EL_COMPLEX_COLUMN_VECTOR [DOUBLE]
			--
		local
			l_num_points: EL_MATLAB_DOUBLE
		do
			create l_num_points.make (num_points.to_double)
			internal_vector.set_from_array (column_vector)
			internal_matlab_complex_column_vector.set_from_mx_pointer (
				c_n_point_discrete_fourier_transform (internal_vector.item, l_num_points.item)
			)
			Result := internal_matlab_complex_column_vector.to_complex_column_vector
		end

	inverse_discrete_fourier_transform (
		complex_column_vector: EL_COMPLEX_COLUMN_VECTOR [DOUBLE]

	): EL_COMPLEX_COLUMN_VECTOR [DOUBLE]
			--
		do
			internal_complex_column_vector.set_from_complex_column_vector (complex_column_vector)
			internal_matlab_complex_column_vector.set_from_mx_pointer (
				c_inverse_discrete_fourier_transform (internal_complex_column_vector.item)
			)
			Result := internal_matlab_complex_column_vector.to_complex_column_vector
		end

feature {NONE} -- Implementation

	internal_vector: EL_MATLAB_COLUMN_VECTOR_DOUBLE
			--
		once
			create Result.make (1)
		end

	internal_complex_column_vector: EL_MATLAB_COMPLEX_COLUMN_VECTOR_DOUBLE
			--
		once
			create Result.make (1)
		end

	internal_matlab_complex_column_vector: EL_MATLAB_COMPLEX_COLUMN_VECTOR_DOUBLE
			--
		once
			create Result.make (1)
		end


feature {NONE} -- C externals

	c_n_point_discrete_fourier_transform (x, n: POINTER): POINTER
			-- Y = fft(X,n) returns the n-point DFT. If the length of X is less than n, X is
			-- padded with trailing zeros to length n. If the length of X is greater than n,
			-- the sequence X is truncated. When X is a matrix, the length of the columns
			-- are adjusted in the same manner.

			-- extern mxArray * mlfFft(mxArray *in1, mxArray *in2, mxArray *in3)

		external
			"C inline use <libmatlbmx.h>"
		alias
			"mlfFft ((mxArray *)$x, (mxArray *)$n, NULL)"
		end

	c_inverse_discrete_fourier_transform (x: POINTER): POINTER
			-- inverse discrete Fourier transform (DFT) of vector x,
			-- computed with a fast Fourier transform (FFT) algorithm.

			-- extern mxArray * mlfIfft(mxArray *in1, mxArray *in2, mxArray *in3);

		external
			"C inline use <libmatlbmx.h>"
		alias
			"mlfIfft ((mxArray *)$x, NULL, NULL)"
		end
end
