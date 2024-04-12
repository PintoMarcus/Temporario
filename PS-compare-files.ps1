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

        # Verifica se os arquivos têm o mesmo número de linhas
        if ($conteudoOrigem.Count -ne $conteudoDestino.Count) {
            $resultado = "$origem e $destino têm número diferente de linhas"
        } else {
            # Comparação linha a linha
            $iguais = $true
            for ($i = 0; $i -lt $conteudoOrigem.Count; $i++) {
                if ($conteudoOrigem[$i] -ne $conteudoDestino[$i]) {
                    $iguais = $false
                    break
                }
            }

            # Verifica se os arquivos são 100% iguais
            if ($iguais) {
                $resultado = "$origem e $destino são IGUAIS"
            } else {
                # Verifica se os arquivos têm diferença apenas nos decimais
                $iguaisComDecimal = $true
                for ($i = 0; $i -lt $conteudoOrigem.Count; $i++) {
                    $origemSemAspas = $conteudoOrigem[$i] -replace '"', ''
                    $destinoSemAspas = $conteudoDestino[$i] -replace '"', ''
                    if ($origemSemAspas -match '^\d+,\d+$' -and $destinoSemAspas -match '^\d+,\d+$') {
                        if ($origemSemAspas -ne $destinoSemAspas) {
                            $iguaisComDecimal = $false
                            break
                        }
                    } else {
                        $iguaisComDecimal = $false
                        break
                    }
                }

                # Verifica se os arquivos são IGUAIS com Decimal ou DIFERENTES
                if ($iguaisComDecimal) {
                    $resultado = "$origem e $destino são IGUAIS com Decimal"
                } else {
                    $resultado = "$origem e $destino são DIFERENTES"
                }
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


####################################
#usando file hash
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

        # Calcular o hash MD5 dos arquivos de origem e destino
        $hashOrigem = (Get-FileHash -Path $origem -Algorithm MD5).Hash
        $hashDestino = (Get-FileHash -Path $destino -Algorithm MD5).Hash

        # Verifica se os hashes são iguais
        if ($hashOrigem -eq $hashDestino) {
            $resultado = "$origem e $destino são IGUAIS"
        } else {
            # Ler o conteúdo dos arquivos
            $conteudoOrigem = Get-Content $origem
            $conteudoDestino = Get-Content $destino

            # Verificar se a diferença está apenas nos campos decimais
            $iguaisComDecimal = $true
            for ($i = 0; $i -lt $conteudoOrigem.Count; $i++) {
                $origemSemAspas = $conteudoOrigem[$i] -replace '"', ''
                $destinoSemAspas = $conteudoDestino[$i] -replace '"', ''
                if ($origemSemAspas -match '^\d+,\d+$' -and $destinoSemAspas -match '^\d+,\d+$') {
                    if ($origemSemAspas -ne $destinoSemAspas) {
                        $iguaisComDecimal = $false
                        break
                    }
                } else {
                    $iguaisComDecimal = $false
                    break
                }
            }

            # Se a diferença estiver apenas nos campos decimais
            if ($iguaisComDecimal) {
                $resultado = "$origem e $destino são IGUAIS com DECIMAL"
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
