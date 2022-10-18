#!/bin/sh

make && \
L4V_ARCH="ARM" isabelle jedit -d generated/ -d ../../cogent/autocorres/ -d ../../cogent/cogent/isa -d ../../cogent/c-refinement/ -l CogentCRefinement DriverProof.thy
