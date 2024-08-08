# Lê arquiuvo do perfom e converte para csv, depois filtra as colunas que contém "*Network Interface*" 

#relog -f csv "C:\PerfLogs\System\Performance\KMS-NB106_20240808-000001\PerformanceCounter.blg" -o "C:\temp\00.csv"

# Define o diretório onde os arquivos .blg estão localizados
$rootDirectory = "C:\PerfLogs\System\Performance\KMS-NB106_20240808-000002"

# Define o caminho para o arquivo CSV de saída único
$outputCsvPath = "C:\temp\001.csv"

# Se o arquivo CSV de saída já existir, apague-o
if (Test-Path $outputCsvPath) {
    Remove-Item $outputCsvPath
}

# Obtenha todos os arquivos .blg no diretório e subdiretórios
$blgFiles = Get-ChildItem -Path $rootDirectory -Recurse -Filter *.blg

# Converta e filtre os dados de cada arquivo .blg
foreach ($blgFile in $blgFiles) {
    $tempCsvPath = [System.IO.Path]::GetTempFileName() + ".csv"
    
    # Converte o arquivo .blg para .csv
    relog.exe $blgFile.FullName -f CSV -o $tempCsvPath

    # Filtra as colunas que contêm "Network Interface"
    if (Test-Path $tempCsvPath) {
        # Read the entire CSV into memory
        $csvContent = Import-Csv $tempCsvPath

        # Get headers and filter columns
        $headers = $csvContent[0].PSObject.Properties.Name
        $networkInterfaceColumns = $headers | Where-Object { $_ -like "*Network Interface*" }

        if ($networkInterfaceColumns.Count -gt 0) {
            # Export only the filtered columns to a new CSV
            $csvContent | Select-Object $networkInterfaceColumns | Export-Csv -Path $outputCsvPath -NoTypeInformation -Append
        }

        # Remove o arquivo CSV temporário
        Remove-Item $tempCsvPath
    }
}

Write-Host "Conversão e filtragem concluídas com sucesso! O arquivo CSV foi salvo em $outputCsvPath"
