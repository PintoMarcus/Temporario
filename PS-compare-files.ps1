################################
#### COMPARE USANDO HASH
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
            $resultado = "$origem e $destino são DIFERENTES"
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



################################
#### COMPARE V01
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

###############################################
REMOVE ZEROS e VÍRGULAS
# Caminho do arquivo lista.txt
$caminhoLista = "C:\temp\compare-origem\lista2.txt"

# Verifica se o arquivo de lista existe
if (Test-Path $caminhoLista) {
    # Lê o conteúdo do arquivo lista.txt
    $arquivos = Get-Content $caminhoLista

    # Loop através de cada arquivo na lista
    foreach ($arquivo in $arquivos) {
        # Verifica se o arquivo existe
        if (Test-Path $arquivo) {
            # Lê o conteúdo do arquivo
            $conteudo = Get-Content $arquivo

            # Remove todos os caracteres "0" e ","
            $conteudoSemZerosVirgulas = $conteudo -replace '[0,]', ''

            # Sobrescreve o arquivo com o conteúdo modificado
            $conteudoSemZerosVirgulas | Set-Content $arquivo -Force

            Write-Host "Zeros e vírgulas removidos do arquivo: $arquivo"
        } else {
            Write-Host "O arquivo $arquivo não foi encontrado."
        }
    }
} else {
    Write-Host "O arquivo $caminhoLista não foi encontrado."
}

############################################################################################################################################
######################################################################
# compare removendo zeros e vírgulas
######################################################################
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
            # Lê o conteúdo dos arquivos
            $conteudoOrigem = Get-Content $origem
            $conteudoDestino = Get-Content $destino

            # Remove todos os caracteres "0" e ","
            $conteudoOrigemSemZerosVirgulas = $conteudoOrigem -replace '[0,]', ''
            $conteudoDestinoSemZerosVirgulas = $conteudoDestino -replace '[0,]', ''

            # Verificar se os arquivos são iguais após a remoção de zeros e vírgulas
            if ($conteudoOrigemSemZerosVirgulas -eq $conteudoDestinoSemZerosVirgulas) {
                $resultado = "$origem e $destino são IGUAIS com DECIMAL"
            } else {
                # Escreve os resultados intermediários no arquivo de resultado
                $resultado = "$origem e $destino são DIFERENTES"
                $resultados += $resultado
                
                # Remove os zeros e vírgulas apenas se os arquivos forem diferentes
                $conteudoOrigemSemZerosVirgulas | Set-Content $origem -Force
                $conteudoDestinoSemZerosVirgulas | Set-Content $destino -Force

                Write-Host "Zeros e vírgulas removidos dos arquivos diferentes: $origem e $destino"
            }
        }

        # Adicionando o resultado ao array
        $resultados += $resultado
    }

    # Escreve os resultados finais no arquivo de resultado
    $resultados | Out-File -FilePath $caminhoResultado -Encoding utf8

    Write-Host "Processo concluído. Resultados salvos em $caminhoResultado"
} else {
    Write-Host "O arquivo $caminhoLista não foi encontrado."
}

