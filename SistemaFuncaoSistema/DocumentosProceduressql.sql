  
/*******************************************************************   
* PROCEDURE: FI_SP_IncClienteV2  
  
* DESCRICAO: Insere um novo cliente na tabela CLIENTES e retorna o ID gerado.  
  
* NOTAS: Atualizado para suportar a gravação do CPF.  
  
* CRIADO POR: Devs Função Sistemas       
  
* MODIFICADO        
* DATA         AUTOR                  DESCRICAO              
20260331    Gabriel Santos        Alteração para inclusão do campo CPF.  
*-------------------------------------------------------------------              
* EXEC dbo.FI_SP_IncClienteV2 @NOME = '',           -- varchar(50)  
                            @SOBRENOME = '',      -- varchar(255)  
                            @NACIONALIDADE = '',  -- varchar(50)  
                            @CEP = '',            -- varchar(9)  
                            @ESTADO = '',         -- varchar(2)  
                            @CIDADE = '',         -- varchar(50)  
                            @LOGRADOURO = '',     -- varchar(500)  
                            @EMAIL = '',          -- varchar(2079)  
                            @TELEFONE = '',       -- varchar(15)     
                            @CPF = ''             -- varchar(14)  
*******************************************************************/    
CREATE PROC FI_SP_IncClienteV2  
    @NOME          VARCHAR (50) ,  
    @SOBRENOME     VARCHAR (255),  
    @NACIONALIDADE VARCHAR (50) ,  
    @CEP           VARCHAR (9)  ,  
    @ESTADO        VARCHAR (2)  ,  
    @CIDADE        VARCHAR (50) ,  
    @LOGRADOURO    VARCHAR (500),  
    @EMAIL         VARCHAR (2079),  
    @TELEFONE      VARCHAR (15),  
    @CPF           VARCHAR (14)   
AS  
BEGIN  
    INSERT INTO CLIENTES (NOME, SOBRENOME, NACIONALIDADE, CEP, ESTADO, CIDADE, LOGRADOURO, EMAIL, TELEFONE, CPF)  
    VALUES (@NOME, @SOBRENOME, @NACIONALIDADE, @CEP, @ESTADO, @CIDADE, @LOGRADOURO, @EMAIL, @TELEFONE, @CPF)  
  
    SELECT SCOPE_IDENTITY()  
END  


  
/*******************************************************************   
* PROCEDURE: FI_SP_AltCliente  
  
* DESCRICAO: Altera os dados de um cliente existente com base no ID.  
  
* NOTAS: Atualizado para suportar a alteração do CPF.  
  
* CRIADO POR: Devs Função Sistemas       
  
* MODIFICADO        
* DATA         AUTOR                  DESCRICAO              
20260331    Gabriel Sanntos             Alteração para inclusão do campo CPF.  
*-------------------------------------------------------------------              
* EXEC dbo.FI_SP_AltCliente   @NOME = '',           -- varchar(50)  
                            @SOBRENOME = '',      -- varchar(255)  
                            @NACIONALIDADE = '',  -- varchar(50)  
                            @CEP = '',            -- varchar(9)  
                            @ESTADO = '',         -- varchar(2)  
                            @CIDADE = '',         -- varchar(50)  
                            @LOGRADOURO = '',     -- varchar(500)  
                            @EMAIL = '',          -- varchar(2079)  
                            @TELEFONE = '',       -- varchar(15)     
                            @CPF = '',            -- varchar(14)  
                            @Id = 0               -- bigint  
*******************************************************************/   
CREATE PROC FI_SP_AltCliente  
    @NOME          VARCHAR (50) ,  
    @SOBRENOME     VARCHAR (255),  
    @NACIONALIDADE VARCHAR (50) ,  
    @CEP           VARCHAR (9)  ,  
    @ESTADO        VARCHAR (2)  ,  
    @CIDADE        VARCHAR (50) ,  
    @LOGRADOURO    VARCHAR (500),  
    @EMAIL         VARCHAR (2079),  
    @TELEFONE      VARCHAR (15),  
    @CPF           VARCHAR (14),   
    @Id            BIGINT  
AS  
BEGIN  
    UPDATE CLIENTES  
    SET  
        NOME = @NOME,  
        SOBRENOME = @SOBRENOME,  
        NACIONALIDADE = @NACIONALIDADE,  
        CEP = @CEP,  
        ESTADO = @ESTADO,  
        CIDADE = @CIDADE,  
        LOGRADOURO = @LOGRADOURO,  
        EMAIL = @EMAIL,  
        TELEFONE = @TELEFONE,  
        CPF = @CPF  
    WHERE Id = @Id  
END  

  
/*******************************************************************   
* PROCEDURE: FI_SP_VerificaCliente  
  
* DESCRICAO: Verifica a existência de um cliente na base através do CPF.  
  
* NOTAS:   
  
* CRIADO POR: Devs Função Sistemas       
  
* MODIFICADO        
* DATA         AUTOR                  DESCRICAO              
20260331    Gabriel Sanntos             Ajuste para validação de unicidade.  
*-------------------------------------------------------------------              
* EXEC dbo.FI_SP_VerificaCliente @CPF = ''          -- varchar(14)  
*******************************************************************/   
CREATE PROC FI_SP_VerificaCliente  
    @CPF VARCHAR(14)  
AS  
BEGIN  
    SELECT 1 FROM CLIENTES WHERE CPF = @CPF  
END  



  
/*******************************************************************   
* PROCEDURE: FI_SP_IncBeneficiario  
  
* DESCRICAO: Insere um novo beneficiário atrelado a um cliente.  
  
* NOTAS:   
  
* CRIADO POR: Gabriel Sanntos       
  
* MODIFICADO        
* DATA         AUTOR                  DESCRICAO              
20260331    Gabriel Sanntos        Criação da procedure.  
*-------------------------------------------------------------------              
* EXEC dbo.FI_SP_IncBeneficiario @CPF = '',         -- varchar(14)  
                                 @NOME = '',        -- varchar(50)  
                                 @IDCLIENTE = 0     -- bigint  
*******************************************************************/   
CREATE PROC FI_SP_IncBeneficiario  
    @CPF VARCHAR(14),  
    @NOME VARCHAR(50),  
    @IDCLIENTE BIGINT  
AS  
BEGIN  
    INSERT INTO BENEFICIARIOS (CPF, NOME, IDCLIENTE)  
    VALUES (@CPF, @NOME, @IDCLIENTE)  
END  


  
/*******************************************************************   
* PROCEDURE: FI_SP_AltBeneficiario  
  
* DESCRICAO: Altera os dados (CPF e NOME) de um beneficiário existente.  
  
* NOTAS:   
  
* CRIADO POR: Gabriel Sanntos       
  
* MODIFICADO        
* DATA         AUTOR                  DESCRICAO              
20260331    Gabriel Sanntos        Criação da procedure.  
*-------------------------------------------------------------------              
* EXEC dbo.FI_SP_AltBeneficiario @ID = 0,           -- bigint  
                                 @CPF = '',         -- varchar(14)  
                                 @NOME = '',        -- varchar(50)  
                                 @IDCLIENTE = 0     -- bigint  
*******************************************************************/   
CREATE PROC FI_SP_AltBeneficiario  
    @ID BIGINT,  
    @CPF VARCHAR(14),  
    @NOME VARCHAR(50),  
    @IDCLIENTE BIGINT  
AS  
BEGIN  
    UPDATE BENEFICIARIOS  
    SET CPF = @CPF, NOME = @NOME, IDCLIENTE = @IDCLIENTE  
    WHERE ID = @ID  
END  


  
/*******************************************************************   
* PROCEDURE: FI_SP_DelBeneficiario  
  
* DESCRICAO: Exclui um beneficiário da base de dados através do seu ID.  
  
* NOTAS:   
  
* CRIADO POR: Gabriel Sanntos       
  
* MODIFICADO        
* DATA         AUTOR                  DESCRICAO              
20260331    Gabriel Sanntos        Criação da procedure.  
*-------------------------------------------------------------------              
* EXEC dbo.FI_SP_DelBeneficiario @ID = 0            -- bigint  
*******************************************************************/   
CREATE PROC FI_SP_DelBeneficiario  
    @ID BIGINT  
AS  
BEGIN  
    DELETE FROM BENEFICIARIOS WHERE ID = @ID  
END  


  
/*******************************************************************   
* PROCEDURE: FI_SP_ConsBeneficiario  
  
* DESCRICAO: Consulta todos os beneficiários vinculados a um cliente.  
  
* NOTAS:   
  
* CRIADO POR: Gabriel Sanntos       
  
* MODIFICADO        
* DATA         AUTOR                  DESCRICAO              
20260331    Gabriel Sanntos        Criação da procedure.  
*-------------------------------------------------------------------              
* EXEC dbo.FI_SP_ConsBeneficiario @IDCLIENTE = 0    -- bigint  
*******************************************************************/   
CREATE   PROC FI_SP_ConsBeneficiario  
    @IDCLIENTE BIGINT  
AS  
BEGIN  
    SELECT ID, CPF, NOME, IDCLIENTE   
    FROM BENEFICIARIOS   
    WHERE IDCLIENTE = @IDCLIENTE  
END  



  
/*******************************************************************   
* PROCEDURE: FI_SP_VerificaBeneficiario  
* DESCRICAO: Verifica se já existe um beneficiário com o mesmo CPF para o mesmo cliente, ignorando o próprio registro na edição.  
* NOTAS:   
* CRIADO POR: Gabriel Sanntos       
* MODIFICADO        
* DATA         AUTOR                  DESCRICAO              
20260331    Gabriel Sanntos        Criação da procedure.  
*-------------------------------------------------------------------              
* EXEC dbo.FI_SP_VerificaBeneficiario @CPF = '',         -- varchar(14)  
                                      @IDCLIENTE = 0,    -- bigint  
                                      @ID = 0            -- bigint  
*******************************************************************/   
CREATE PROC FI_SP_VerificaBeneficiario  
    @CPF VARCHAR(14),  
    @IDCLIENTE BIGINT,  
    @ID BIGINT  
AS  
BEGIN  
    SELECT 1 FROM BENEFICIARIOS   
    WHERE CPF = @CPF AND IDCLIENTE = @IDCLIENTE AND ID <> @ID  
END  



  
/*******************************************************************   
* PROCEDURE: FI_SP_PesqCliente  
  
* DESCRICAO: Realiza a pesquisa e listagem paginada de clientes.  
  
* NOTAS: Atualizado para retornar o CPF na grid.  
  
* CRIADO POR: Devs Função Sistemas       
* MODIFICADO        
* DATA         AUTOR                  DESCRICAO              
20260331    Gabriel Sanntos        Inclusão da coluna CPF no retorno.  
*-------------------------------------------------------------------              
* EXEC dbo.FI_SP_PesqCliente @iniciarEm = 0,        -- int  
                             @quantidade = 10,      -- int  
                             @campoOrdenacao = '',  -- varchar(200)  
                             @crescente = 1         -- bit  
*******************************************************************/   
CREATE PROC FI_SP_PesqCliente  
    @iniciarEm int,  
    @quantidade int,  
    @campoOrdenacao varchar(200),  
    @crescente bit    
AS  
BEGIN  
    DECLARE @SCRIPT NVARCHAR(MAX)  
    DECLARE @CAMPOS NVARCHAR(MAX)  
    DECLARE @ORDER VARCHAR(50)  
      
    IF(@campoOrdenacao = 'EMAIL')  
        SET @ORDER =  ' EMAIL '  
    ELSE  
        SET @ORDER = ' NOME '  
  
    IF(@crescente = 0)  
        SET @ORDER = @ORDER + ' DESC'  
    ELSE  
        SET @ORDER = @ORDER + ' ASC'  
  
    SET @CAMPOS = '@iniciarEm int,@quantidade int'  
    SET @SCRIPT =   
    'SELECT ID, NOME, SOBRENOME, NACIONALIDADE, CEP, ESTADO, CIDADE, LOGRADOURO, EMAIL, TELEFONE, CPF FROM  
        (SELECT ROW_NUMBER() OVER (ORDER BY ' + @ORDER + ') AS Row, ID, NOME, SOBRENOME, NACIONALIDADE, CEP, ESTADO, CIDADE, LOGRADOURO, EMAIL, TELEFONE, CPF FROM CLIENTES WITH(NOLOCK))  
        AS ClientesWithRowNumbers  
    WHERE Row > @iniciarEm AND Row <= (@iniciarEm + @quantidade) ORDER BY'  
      
    SET @SCRIPT = @SCRIPT + @ORDER  
              
    EXECUTE SP_EXECUTESQL @SCRIPT, @CAMPOS, @iniciarEm, @quantidade  
  
    SELECT COUNT(1) FROM CLIENTES WITH(NOLOCK)  
END  


  
/*******************************************************************   
* PROCEDURE: FI_SP_ConsCliente  
  
* DESCRICAO: Consulta os dados de um cliente específico ou lista todos.  
  
* NOTAS: Atualizado para retornar o CPF.  
  
* CRIADO POR: Devs Função Sistemas       
  
* MODIFICADO        
* DATA         AUTOR                  DESCRICAO              
20260331    Gabriel Sanntos        Inclusão da coluna CPF no retorno.  
*-------------------------------------------------------------------              
* EXEC dbo.FI_SP_ConsCliente @ID = 0                -- bigint  
*******************************************************************/   
CREATE PROC FI_SP_ConsCliente  
    @ID BIGINT  
AS  
BEGIN  
    IF(ISNULL(@ID,0) = 0)  
        SELECT NOME, SOBRENOME, NACIONALIDADE, CEP, ESTADO, CIDADE, LOGRADOURO, EMAIL, TELEFONE, ID, CPF FROM CLIENTES WITH(NOLOCK)  
    ELSE  
        SELECT NOME, SOBRENOME, NACIONALIDADE, CEP, ESTADO, CIDADE, LOGRADOURO, EMAIL, TELEFONE, ID, CPF FROM CLIENTES WITH(NOLOCK) WHERE ID = @ID  
END  