These classes implement matrices and vectors for DOUBLEs and COMPLEX_DOUBLEs.

VECTOR_DOUBLE is a subclass of MATRIX_DOUBLE, so it's possible to multiply a matrix by a vector as is usual for computational linear algebra.

VECTOR_DOUBLE_2 is a convenience class that allows you to refer to the entries in a two dimensional vector as x and y. VECTOR_DOUBLE_3 allows you to refer to its entries as x, y, and z and includes a cross product function.

MATRIX_DOUBLE includes determinant and inverse functions. For work with matrices that are singular or nearly so, you should look at using the singular value decomposition classes implemented in the SVD cluster.

Greg Lee
October 2005
