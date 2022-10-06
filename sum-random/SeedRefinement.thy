theory SeedRefinement
imports "lib/CogentMonad"
        "lib/CogentCorres"
        "build/Random_seed_AllRefine"
begin        

section\<open> The shallow Cogent code refines a non-deterministic monad representing the set of all values \<close>

text \<open>This is trivial to prove as any program refines the set of all values but the set up should 
      allow for verifying a more interesting example involving for instance specifying the output of 
      a deterministic function that calls a non-deterministic one.\<close>


abbreviation "rand_with_seed_spec \<equiv> UNIV:: 64 word cogent_monad"
abbreviation "sum_spec \<equiv> UNIV:: 64 word cogent_monad"

abbreviation "val_rel_monadic_shallow \<equiv> (\<lambda>(v:: 'b) sv:: ('a, 'b) SeedValue. v =  value\<^sub>f sv)"


(*NOTE that this is trivial*)
lemma all_functions_refine_UNIV :
  "\<And>s. cogent_corres val_rel_monadic_shallow UNIV (func s)"
by(simp add:cogent_corres_def)

(*NOTE that this is trivial -- any function would satisfy this spec *)
lemma rand_with_seed_corres_monad_shallow :
  "\<And>s. cogent_corres val_rel_monadic_shallow rand_with_seed_spec (rand_with_seed s)"
by(simp add:cogent_corres_def)

(*NOTE that this is trivial -- any function would satisfy this spec *)
lemma sum_corres_monad_shallow :
  "\<And>s. cogent_corres val_rel_monadic_shallow sum_spec (Random_seed_Shallow_Desugar.sum s)"
  by(simp add:cogent_corres_def)

