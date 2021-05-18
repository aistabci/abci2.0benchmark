#!/bin/bash
export OMPI_COMM_WORLD_LOCAL_RANK=$(( OMPI_COMM_WORLD_LOCAL_RANK * 2 ))
exec $*
