O objetivo do trabalho era: "Alterar o exemplo de verificação semântica apresentado para realizar a verificação de tipos de chamadas de funições" nas palavras do professor.
Esse trabalho não faz apenas isso, como reconhece structs e arrays inclusive. Foi mudado a estrutura do projeto, agora não tendo suporte para definir na tabela de funções o tipo básico, e agora os tipos básicos estão definidos em um enum. Além disso, o módulo TS_Entry agora salva a classe como uma string simples, sendo descartado o tipo classe anterior.

assim como no exemplo, só é possivel declarar valor a uma variavel dentro de uma classe.

o formato de declaração de função é: "Define tipo ident(tipo arg1; tipo arg2;){ bloco return exp}"

o formato para execução de função é: "ident (arg1, arg2);"

Foram feito 3 casos de teste que cobrem os seguintes cenários: 

1: Erro na declaração de função: O arquivo erroDeclFunc.txt demonstra o erro quando o retorno é diferente do tipo decladado;

2: Declaração de função, struct, array e assinalando a uma variavel o valor de uma função tudo isso é testado no caso de teste meuFuncao.txt

3: Passando o numero errado de argumentos na função é testado no erroNumArgs.txt.