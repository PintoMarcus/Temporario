# Definir os caminhos dos arquivos
$files = @(
    "D:\local_1\arquivo_1.csv",
    "D:\local_2\arquivo_1.csv",
    "D:\local_3\arquivo_1.csv",
    "D:\local_4\arquivo_1.csv"
)

# Definir o caminho do arquivo de saída
$outputFile = "D:\output\merged_arquivo_1.csv"

# Inicializar uma lista para armazenar o conteúdo dos arquivos
$mergedContent = @()

# Iterar sobre os arquivos
for ($i = 0; $i -lt $files.Count; $i++) {
    $fileContent = Get-Content -Path $files[$i]

    if ($i -eq 0) {
        # Para o primeiro arquivo, incluir todas as linhas
        $mergedContent += $fileContent
    } else {
        # Para os arquivos subsequentes, ignorar a primeira linha
        $mergedContent += $fileContent[1..($fileContent.Length - 1)]
    }
}

# Escrever o conteúdo mesclado no arquivo de saída
$mergedContent | Out-File -FilePath $outputFile -Encoding utf8

Write-Host "Arquivos mesclados com sucesso no arquivo $outputFile"
