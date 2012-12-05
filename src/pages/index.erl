-module(index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
 
main() -> wf:redirect("/beta").