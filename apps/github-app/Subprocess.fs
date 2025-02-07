module Subprocess

open System.Diagnostics

let makeProcess file args env workingDirectory =
    let si = System.Diagnostics.ProcessStartInfo(file)
    si.Arguments <- args
    si.WorkingDirectory <- workingDirectory 
    Map.iter (fun k v -> si.EnvironmentVariables[k] <- v) env
    new Process(StartInfo = si)

let runProcess (p : Process) = async {
    p.Start() |> ignore
    do! p.WaitForExitAsync() |> Async.AwaitTask
}

let gh token commands workingDirectory = 
    let env = Map.add "GH_TOKEN" token Map.empty
    let p = makeProcess "gh" commands env workingDirectory
    runProcess p
