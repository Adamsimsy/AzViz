function Get-DOTExecutable {
    
    $PossibleGraphVizPaths = @(
        'C:\Program Files\NuGet\Packages\Graphviz*\dot.exe',
        'C:\program files*\GraphViz*\bin\dot.exe',
        '/usr/local/bin/dot',
        '/usr/bin/dot',
        '/opt/homebrew/bin/dot',
        'C:\Projects\bicep-export\tools\diagram\graphviz.2.38.0.2\dot.exe'
    )

    try {
        $PossibleGraphVizPaths += (Get-Command -Type Application -Name dot).Source
    }
    catch {
        Write-Warning "Could not locate 'dot' command registered as global executable"
    }

    $GraphViz = Resolve-Path -path $PossibleGraphVizPaths -ErrorAction SilentlyContinue | Get-Item | Where-Object BaseName -eq 'dot' | Select-Object -First 1

    return $GraphViz
}

