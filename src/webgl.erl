%% -*- mode: nitrogen -*-
-module (webgl).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").

main() -> #template { file="./site/templates/webgl.html" }.

title() -> "Hello from webgl.erl!".

body() -> 
    [
      
    ].

