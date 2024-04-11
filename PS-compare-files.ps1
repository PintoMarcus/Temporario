# Caminho do arquivo lista.txt
$caminhoLista = "C:\temp\compare-origem\lista.txt"

# Caminho do arquivo de resultado
$caminhoResultado = "C:\temp\compare-origem\resultado.txt"

# Verifica se o arquivo de lista existe
if (Test-Path $caminhoLista) {
    # Leitura do arquivo lista.txt
    $linhas = Get-Content $caminhoLista

    # Array para armazenar os resultados
    $resultados = @()

    # Loop através de cada linha do arquivo lista.txt
    foreach ($linha in $linhas) {
        # Dividindo a linha em origem e destino
        $arquivos = $linha -split ","
        $origem = $arquivos[0].Trim()
        $destino = $arquivos[1].Trim()

        # Comparando os arquivos
        $iguais = Compare-Object (Get-Content $origem) (Get-Content $destino) -SyncWindow 10 -PassThru

        # Verifica se os arquivos são iguais ou diferentes
        if ($iguais) {
            $resultado = "$origem e $destino são DIFERENTES"
        } else {
            $resultado = "$origem e $destino são IGUAIS"
        }

        # Adicionando o resultado ao array
        $resultados += $resultado
    }

    # Escreve os resultados no arquivo de resultado
    $resultados | Out-File -FilePath $caminhoResultado -Encoding utf8

    Write-Host "Processo concluído. Resultados salvos em $caminhoResultado"
} else {
    Write-Host "O arquivo $caminhoLista não foi encontrado."
}
