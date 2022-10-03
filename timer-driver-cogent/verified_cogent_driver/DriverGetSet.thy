theory DriverGetSet
  imports Main "HOL-Word.Word" "Word_Lib.Word_Lib" 
 "generated/Driver_CorresSetup"
begin

context Driver begin

thm GetSetSanity
(* Sanity checks for getters and setters *)
local_setup \<open>local_setup_getset_sanity_lemmas "driver.c"\<close>

thm GetSetSanity
end

end