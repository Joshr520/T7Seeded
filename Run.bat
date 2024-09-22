@echo off
call "Compiler/DebugCompiler.exe" "Code/compiled.gsic" "T7" "scripts/shared/duplicaterender_mgr.gsc" "--inject" "--noupdate"

pause