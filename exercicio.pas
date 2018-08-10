program listaEncadeada;

uses crt;

type 
    ptnodoC = ^cidade;
    cidade = record
        ant: ptnodoC;
        descricaoCidade: string;
        populacaoCidade: integer; 
        areaCidade: real; 
        prox: ptnodoC;
    end;
    ptnodoE = ^estado;
    estado = record
        ant: ptnodoE;
        descricaoEstado: string;
        siglaEstado: string;
        cidadeI: ptnodoC;
        cidadeF: ptnodoC;
        prox: ptnodoE;
    end;

var 
    op: Byte;
    estadoI, estadoF, estadoSelecionado: ptnodoE;
    cidadeI, cidadeF: ptnodoC;
    descricaoEstado, siglaEstado, descricaoCidade: string;
    populacaoCidade: integer;
    areaCidade: real;

procedure criaListaEstado(var estadoI, estadoF: ptnodoE; var cidadeI, cidadeF: ptnodoC);
begin
    estadoI:= nil;
    estadoF:= nil;
    cidadeI:= nil;
    cidadeF:= nil;
end;

procedure leituraEstado(var descricaoEstado, siglaEstado: string; tipoLeitura: string);
begin
    clrscr;
    writeln('Informe qual a Sigla do Estado: ');
    read(siglaEstado);
    if (tipoLeitura = 'completa') then
    begin;
        writeln('Informe o nome do estado: ');
        read(descricaoEstado);
    end;
end;

procedure leituraCidade(var descricaoCidade: string; var populacaoCidade: integer; var areaCidade: real; tipoLeitura: string);
begin
    //clrscr;
    writeln('Informe qual o nome da Cidade: ');
    read(descricaoCidade);
    if (tipoLeitura = 'completa') then
    begin;
        writeln('Informe a população de ' + descricaoCidade + ' :');
        read(populacaoCidade);
        writeln('Informa a àrea de ' + descricaoCidade + ' :');
        read(areaCidade);
    end;
end;

procedure carregaEstado(estadoI: ptnodoE; var estadoSelecionado: ptnodoE; siglaEstado: string);
var aux: ptnodoE;
begin
    aux:= estadoI;
    while (aux^.siglaEstado <> siglaEstado) and (aux <> nil) do
    begin
        aux:= aux^.prox;
    end;
    estadoSelecionado:= aux;
end;

procedure incluirEstado(var estadoI, estadoF: ptnodoE; var descricaoEstado, siglaEstado: string);
var aux, aux2: ptnodoE;
begin
    new(aux);
    if (aux = nil) then 
    begin
        writeln('Memória Cheia'); 
    end
    else
    begin
        aux2:= estadoI;
        if (estadoI = nil) then 
        begin
            aux^.ant:= nil;
            aux^.prox:= nil;
            estadoI:= aux;
            estadoF:= aux;
        end
        else 
        begin
            while (aux2^.siglaEstado < siglaEstado) and (aux2^.prox <> nil) do
            begin
                aux2:= aux2^.prox;
            end;
            if (estadoI^.siglaEstado > siglaEstado) or (estadoI = nil) then //Insere no Começo
            begin
                aux^.ant:= nil;
                aux^.prox:= aux2;
                aux2^.ant:= aux;
                estadoI:= aux;
            end
            else if (aux2^.siglaEstado < siglaEstado) and (aux2^.prox = nil) then //Insere no Final
            begin 
                aux^.ant:= aux2;
                aux^.prox:= nil;
                aux2^.prox:= aux;
                estadoF:= aux;
            end
            else //Insere no Meio
            begin 
                aux^.ant:= aux2^.ant;
                aux^.prox:= aux2;
                aux2^.ant^.prox:= aux;
                aux2^.ant:= aux;
            end;
        end;
        aux^.siglaEstado:= siglaEstado;
        aux^.descricaoEstado:= descricaoEstado;
    end;
end;

procedure incluirCidade(var estadoSelecionado: ptnodoE; var descricaoCidade: string; var populacaoCidade: integer; var areaCidade: real);
var aux, aux2: ptnodoC;
begin
    new(aux);
    if (aux = nil) then 
    begin
        writeln('Memória Cheia'); 
    end
    else
    begin
        aux2:= estadoSelecionado^.cidadeI;
        if (aux2 = nil) then 
        begin
            aux^.ant:= nil;
            aux^.prox:= nil;
            estadoSelecionado^.cidadeI:= aux;
            estadoSelecionado^.cidadeF:= aux;
        end
        else 
        begin
            while (aux2^.descricaoCidade < descricaoCidade) and (aux2^.prox <> nil) do
            begin
                aux2:= aux2^.prox;
            end;
            if (estadoSelecionado^.cidadeI^.descricaoCidade > descricaoCidade) or (estadoSelecionado^.cidadeI = nil) then //Insere no Começo
            begin
                aux^.ant:= nil;
                aux^.prox:= aux2;
                aux2^.ant:= aux;
                estadoSelecionado^.cidadeI:= aux;
            end
            else if (aux2^.descricaoCidade < descricaoCidade) and (aux2^.prox = nil) then //Insere no Final
            begin 
                aux^.ant:= aux2;
                aux^.prox:= nil;
                aux2^.prox:= aux;
                estadoSelecionado^.cidadeF:= aux;
            end
            else //Insere no Meio
            begin 
                aux^.ant:= aux2^.ant;
                aux^.prox:= aux2;
                aux2^.ant^.prox:= aux;
                aux2^.ant:= aux;
            end;
        end;
        aux^.descricaoCidade:= descricaoCidade;
        aux^.populacaoCidade:= populacaoCidade;
        aux^.areaCidade:= areaCidade;
    end;
end;

procedure removerCidade(var estadoSelecionado: ptnodoE; var descricaoCidade: String);
var aux: ptnodoC;
begin
    if (estadoSelecionado^.cidadeI) = nil then
    begin
        writeln('Lista vazia!');
        readkey;
    end
    else
    begin
        aux:= estadoSelecionado^.cidadeI;
        while (aux <> nil) and (aux^.descricaoCidade <> descricaoCidade) do
        begin
            aux:= aux^.prox;
        end;
        if (aux = nil) then
        begin
            writeln('Estado não encontrado!');
        end
        else if (estadoSelecionado^.cidadeI = aux) then //Remove do Começo
        begin
            estadoSelecionado^.cidadeI := aux^.prox;
            aux^.ant:= nil;
        end
        else if (aux^.prox = nil) then //Remove do Final
        begin 
            aux^.ant^.prox:= nil;
            estadoSelecionado^.cidadeF:= aux^.ant;
        end
        else //Remove do Meio
        begin
            aux^.ant^.prox:= aux^.prox;
            aux^.prox^.ant:= aux^.ant;
        end;
        dispose(aux);
    end;
end;

procedure removerEstado(var estadoI, estadoF: ptnodoE; var siglaEstado: String);
var aux: ptnodoE; aux2: ptnodoC;
begin
    if (estadoI = nil) then
    begin
        writeln('Lista vazia!');
        readkey;
    end
    else
    begin
        aux:= estadoI;
        while (aux <> nil) and (aux^.siglaEstado <> siglaEstado) do
        begin
            aux:= aux^.prox;
        end;
        if (aux = nil) then
        begin
            writeln('Estado não encontrado!');
        end
        else 
        begin
            //Remove todas as cidades
            aux2:= aux^.cidadeI;
            while (aux2 <> nil) do
            begin 
                removerCidade(aux, aux2^.descricaoCidade);
                aux2:= aux2^.prox;
            end;
            if (estadoI = aux) then //Remove do Começo
            begin
                estadoI:= aux^.prox;
                aux^.ant:= nil;
            end
            else if (aux^.prox = nil) then //Remove do Final
            begin 
                aux^.ant^.prox:= nil;
                estadoF:= aux^.ant;
            end
            else //Remove do Meio
            begin
                aux^.ant^.prox:= aux^.prox;
                aux^.prox^.ant:= aux^.ant;
            end;
            dispose(aux);
        end;
    end;
end;

procedure listarEstados(estadoI, estadoF: ptnodoE);
var aux: ptnodoE; direcao: string;
begin
    if (estadoI = nil) then
    begin
        writeln('Não Existem Cadastros');
    end
    else
    begin
        writeln('Normal ou Invertida (asc/desc)?');
        read(direcao);
        if (direcao = 'desc') then
            aux:= estadoF
        else
            aux:= estadoI;
        while (aux <> nil) do
        begin
            writeln('Estado: ', aux^.descricaoEstado, ', sigla: ', aux^.siglaEstado);
            if (direcao = 'desc') then
                aux:= aux^.ant
            else 
                aux:= aux^.prox;
        end;
    end;    
end;

procedure listarCidades(estadoI, estadoF, estadoSelecionado: ptnodoE; tipoLeitura: string);
var aux: ptnodoE; aux2: ptnodoC; direcao, direcao2: string;
begin
    if (estadoI = nil) then
    begin
        writeln('Não Existem Cadastros');
    end
    else
    begin
        if (tipoLeitura = 'completa') then
        begin
            writeln('Ordem dos Estados: Normal ou Invertida (asc/desc)?');
            read(direcao);
            if (direcao = 'desc') then
                aux:= estadoF
            else
                aux:= estadoI;
            writeln('Ordem das Cidades: Normal ou Invertida (asc/desc)?');
            read(direcao2);

            while(aux <> nil) do
            begin
                writeln('Estado: ', aux^.descricaoEstado, ', sigla: ', aux^.siglaEstado);
                if (direcao2 = 'desc') then
                    aux2:= aux^.cidadeF
                else
                    aux2:= aux^.cidadeI;
                if (aux2 = nil) then
                begin
                    writeln('Não existem Cidades cadastradas para este Estado');
                end
                else
                begin
                    while(aux2 <> nil) do
                    begin
                        writeln('Cidade: ', aux2^.descricaoCidade, ', população:', aux2^.populacaoCidade, ', área: ', aux2^.areaCidade); 
                        if (direcao2 = 'desc') then
                            aux2:= aux2^.ant
                        else 
                            aux2:= aux2^.prox;
                    end;
                end;
                if (direcao = 'desc') then
                    aux:= aux^.ant
                else 
                    aux:= aux^.prox;
            end;
        end
        else
        begin
            aux:= estadoSelecionado;
            writeln('Ordem das Cidades: Normal ou Invertida (asc/desc)?');
            read(direcao2);
            if (direcao2 = 'desc') then
                aux2:= estadoSelecionado^.cidadeF
            else
                aux2:= estadoSelecionado^.cidadeI;
            writeln('Estado: ', aux^.descricaoEstado, ', sigla: ', aux^.siglaEstado);
            if (aux2 = nil) then
            begin
                writeln('Não existem Cidades cadastradas para este Estado');
            end
            else
            begin
                while (aux2 <> nil) do
                begin
                    writeln('Cidade: ', aux2^.descricaoCidade, ', população:', aux2^.populacaoCidade, ', área: ', aux2^.areaCidade); 
                    if (direcao2 = 'desc') then
                        aux2:= aux2^.ant
                    else 
                        aux2:= aux2^.prox;
                end;
            end;
        end;
    end;
end;

Begin
    criaListaEstado(estadoI, estadoF, cidadeI, cidadeF);
    op:= 1;
    while op <> 0 do
    begin
        writeln('0 - Sair'); 
        writeln('1 - Incluir Estado');
        writeln('2 - Remover Estado');
        writeln('3 - Listar Estados');
        writeln('4 - Incluir Cidade');
        writeln('5 - Remover Cidade');
        writeln('6 - Listar Todas as Cidades de um Estado');
        writeln('7 - Listar Todas as Cidades de Todos os Estados');
        readln(op);
        case op of 
            1: begin
                leituraEstado(descricaoEstado, siglaEstado, 'completa');
                incluirEstado(estadoI, estadoF, descricaoEstado, siglaEstado);
            end;
            2: begin
                leituraEstado(descricaoEstado, siglaEstado, 'simplificada');
                removerEstado(estadoI, estadoF, siglaEstado);
            end;
            3: begin
                listarEstados(estadoI, estadoF);
                readkey;
            end;
            4: begin
                leituraEstado(descricaoEstado, siglaEstado, 'simplificada');
                carregaEstado(estadoI, estadoSelecionado, siglaEstado);
                if (estadoSelecionado = nil) then
                    writeln('Estado não encontrado!')
                else 
                begin
                    leituraCidade(descricaoCidade, populacaoCidade, areaCidade, 'completa');
                    incluirCidade(estadoSelecionado, descricaoCidade, populacaoCidade, areaCidade);
                end;
            end;
            5: begin
                leituraEstado(descricaoEstado, siglaEstado, 'simplificada');
                carregaEstado(estadoI, estadoSelecionado, siglaEstado);
                if (estadoSelecionado = nil) then
                    writeln('Estado não encontrado!')
                else 
                begin
                    leituraCidade(descricaoCidade, populacaoCidade, areaCidade, 'simplificada');
                    removerCidade(estadoSelecionado, descricaoCidade);
                end;
            end;
            6: begin
                leituraEstado(descricaoEstado, siglaEstado, 'simplificada');
                carregaEstado(estadoI, estadoSelecionado, siglaEstado);
                if (estadoSelecionado = nil) then
                    writeln('Estado não encontrado!')
                else 
                    listarCidades(estadoI, estadoF, estadoSelecionado, 'simplificada');
            end;
            7: begin
                listarCidades(estadoI, estadoF, estadoSelecionado, 'completa');                
            end;
        end;
    end;
End.