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




######################################################
######### TESTE com Decimal ######################
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

        # Leitura do conteúdo dos arquivos
        $conteudoOrigem = Get-Content $origem
        $conteudoDestino = Get-Content $destino

        # Verificando se os arquivos têm o mesmo número de linhas
        if ($conteudoOrigem.Count -ne $conteudoDestino.Count) {
            $resultado = "$origem e $destino têm número diferente de linhas"
        } else {
            # Comparação linha a linha
            $iguais = $true
            for ($i = 0; $i -lt $conteudoOrigem.Count; $i++) {
                if ($conteudoOrigem[$i] -ne $conteudoDestino[$i]) {
                    # Verifica se a diferença é apenas devido a valores numéricos com vírgula
                    $origemSemAspas = $conteudoOrigem[$i] -replace '"', ''
                    $destinoSemAspas = $conteudoDestino[$i] -replace '"', ''
                    if ($origemSemAspas -match '^\d+,\d+$' -and $destinoSemAspas -match '^\d+,\d+$') {
                        # Remove os zeros finais
                        $origemSemZeros = $origemSemAspas.TrimEnd('0')
                        $destinoSemZeros = $destinoSemAspas.TrimEnd('0')
                        # Compara se os valores são iguais após remover os zeros finais
                        if ($origemSemZeros -ne $destinoSemZeros) {
                            $iguais = $false
                            break
                        }
                    } else {
                        $iguais = $false
                        break
                    }
                }
            }

            # Verifica se os arquivos são iguais ou diferentes
            if ($iguais) {
                # Verifica se os arquivos são 100% iguais ou têm diferença apenas devido a ajuste decimal
                if ($conteudoOrigem -eq $conteudoDestino) {
                    $resultado = "$origem e $destino são IGUAIS"
                } else {
                    $resultado = "$origem e $destino são IGUAIS com Decimal"
                }
            } else {
                $resultado = "$origem e $destino são DIFERENTES"
            }
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
