/* -*- mode: C -*-  */
/* 
   IGraph library.
   Copyright (C) 2003-2012  Gabor Csardi <csardi.gabor@gmail.com>
   334 Harvard street, Cambridge, MA 02139 USA
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc.,  51 Franklin Street, Fifth Floor, Boston, MA 
   02110-1301 USA

*/

#ifndef REST_MEMORY_H
#define REST_MEMORY_H

#include <stdlib.h>

#undef __BEGIN_DECLS
#undef __END_DECLS
#ifdef __cplusplus
# define __BEGIN_DECLS extern "C" {
# define __END_DECLS }
#else
# define __BEGIN_DECLS /* empty */
# define __END_DECLS /* empty */
#endif

__BEGIN_DECLS

#define igraph_Calloc(n,t)    (t*) calloc( (size_t)(n), sizeof(t) )
#define igraph_Realloc(p,n,t) (t*) realloc((void*)(p), (size_t)((n)*sizeof(t)))
#define igraph_Free(p)        (free( (void *)(p) ), (p) = NULL)

/* #ifndef IGRAPH_NO_CALLOC */
/* #  define Calloc igraph_Calloc */
/* #  define Realloc igraph_Realloc */
/* #  define Free igraph_Free */
/* #endif */

int igraph_free(void *p);
void *igraph_malloc(size_t n);

__END_DECLS

#endif
