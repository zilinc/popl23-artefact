#!/bin/sh

make && \
L4V_ARCH="ARM" isabelle jedit -d . -d ../cogent/autocorres/ -d ../cogent/cogent/isa -d ../cogent/c-refinement/ -l CogentCRefinement Generated_AllRefine.thy
