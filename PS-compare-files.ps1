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


-----

DECLARE @TableName NVARCHAR(MAX) = 'AWBuildVersion';
DECLARE @Query NVARCHAR(MAX) = '';
DECLARE @Columns NVARCHAR(MAX) = '';

SELECT @Columns = @Columns + 
    CASE 
        WHEN c.DATA_TYPE = 'decimal' THEN
            'CASE ' +
            'WHEN ' + QUOTENAME(c.COLUMN_NAME) + ' = ROUND(' + QUOTENAME(c.COLUMN_NAME) + ', 0) THEN FORMAT(' + QUOTENAME(c.COLUMN_NAME) + ', ''0'') ' +
            'ELSE FORMAT(' + QUOTENAME(c.COLUMN_NAME) + ', ''0.##########'') ' +
            'END AS ' + QUOTENAME(c.COLUMN_NAME) + ', '
        ELSE
            QUOTENAME(c.COLUMN_NAME) + ', '
    END
FROM INFORMATION_SCHEMA.COLUMNS c
INNER JOIN sys.types t ON c.DATA_TYPE = t.name
WHERE c.TABLE_NAME = @TableName;

SET @Columns = LEFT(@Columns, LEN(@Columns) - 1);

SET @Query = 'SELECT ' + @Columns + ' FROM ' + @TableName;

EXEC sp_executesql @Query;
