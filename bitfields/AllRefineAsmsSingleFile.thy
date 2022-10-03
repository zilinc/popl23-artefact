theory AllRefineAsmsSingleFile
  imports
Cogent.ValueSemantics
 "build/Bitfields_AllRefine"
   
begin

section "Functional correctness of 'foo'"

definition foo_spec :: "R\<^sub>T \<Rightarrow> R\<^sub>T"
  where "foo_spec f = 
(if exide\<^sub>f f then
f \<lparr> id\<^sub>f := id\<^sub>f f && 0x0c \<rparr>
else
f \<lparr> id\<^sub>f := id\<^sub>f f + 1 \<rparr>)"

lemma foo_shallow_correct: "Bitfields_Shallow_Desugar.foo x = foo_spec x"
  apply(clarsimp  simp add:foo_spec_def Bitfields_Shallow_Desugar.foo_def Let\<^sub>d\<^sub>s_def)
  
  apply(cases "exide\<^sub>f x"; clarsimp)
   apply(rule_tac f =" \<lambda> f . x \<lparr> id\<^sub>f := f \<rparr>" in  HOL.arg_cong )
   apply word_bitwise
  apply(rule_tac f =" \<lambda> f . x \<lparr> id\<^sub>f := f \<rparr>" in  HOL.arg_cong )
  apply word_bitwise
  done

lemmas corres_shallow_C_foo_concrete =  Bitfields_cogent_shallow.corres_shallow_C_foo[folded \<Xi>_def, simplified
, simplified, simplified foo_shallow_correct
]

end