/* -*- mode: C -*-  */
/* vim:set ts=8 sw=2 sts=2 et: */
/* 
   IGraph R library.
   Copyright (C) 2003-2013  Gabor Csardi <csardi.gabor@gmail.com>
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
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 
   02110-1301 USA

*/

#include <igraph.h>

int main() {
  igraph_t g1, g2;
  igraph_rng_t rng;
  igraph_rng_init(&rng, &igraph_rngtype_mt19937);

  igraph_erdos_renyi_game(&g1, IGRAPH_ERDOS_RENYI_GNP, 10, .3,
                          IGRAPH_UNDIRECTED, IGRAPH_NO_LOOPS, &rng);
  igraph_correlated_game(&g1, &g2, .9, .3, /* permutation=*/ 0);
  
  igraph_rng_destroy(&rng);
  igraph_destroy(&g2);
  igraph_destroy(&g1);
  
  return 0;
}
