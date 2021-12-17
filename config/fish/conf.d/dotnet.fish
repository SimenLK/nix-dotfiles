which dotnet &> /dev/null
if test $status
    complete --command dotnet --arguments '(dotnet complete (commandline -cp))'
end
