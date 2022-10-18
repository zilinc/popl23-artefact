#!/bin/sh

make && \
L4V_ARCH="ARM" isabelle jedit -d build/ -d ../cogent/autocorres/ -d ../cogent/cogent/isa -d ../cogent/c-refinement/ -l CogentCRefinement SeedRefinement.thy
