    
%{
  import java.io.*;
  import java.util.*;
%}


%token IDENT, INT, DOUBLE, BOOL, NUM, STRING, RETURN
%token LITERAL, AND, VOID, MAIN, IF, DEFINE
%token STRUCT

%right '='
%nonassoc '>'
%left '+'
%left AND
%left '[' 
%left '.' 
%left RETURN 

%type <sval> IDENT
%type <ival> NUM
%type <obj> type
%type <obj> exp
%type <obj> lvalue

%%

prog : { currClass = "VarGlobal"; } dList main ;

dList : decl dList | ;

decl : type IDENT ';' { TS_entry nodo = ts.pesquisa($2);
                        if (nodo != null) 
                        yyerror("(sem) variavel >" + $2 + "< jah declarada");
                        else ts.insert(new TS_entry($2, (Tipo)$1, currClass)); 
                      }
      | type '[' exp ']' IDENT ';' { TS_entry nodo = ts.pesquisa($5);
                                     if (nodo != null) 
                                       yyerror("(sem) array >" + $5 + "< jah declarado");
                                     else if($3 != Tipo.INT){
                                       yyerror("array precisa ter indices inteiros");
                                     }
                                     else{
                                      ts.insert(new TS_entry($5, Tipo.ARRAY, currClass, (Tipo)$1));
                                     }
                                   }
      | type IDENT {  TS_entry nodo = ts.pesquisa($2);
                      if (nodo != null) 
                        yyerror("(sem) struct >" + $2 + "< jah declarado");
                      else if($1 != Tipo.STRUCT){
                        yyerror("oops, isso n eh um struct");
                      }
                      else{
                        ts.insert(new TS_entry($2, Tipo.STRUCT, currClass));
                        ts = ts.pesquisa($2).getTabelaSimb();
                      }
                    } 
                                                                        '{' dList '}' {ts = tabelaSimbolos;}
      | DEFINE type IDENT { Funcao nodo = tf.pesquisa($3);
                      if (nodo != null) 
                        yyerror("(sem) funcao >" + $2 + "< jah declarado");
                      else{
                        tf.insert(new Funcao($3, (Tipo)$2, currClass));
                        ts = tf.pesquisa($3).getListaParams();
                      }
                    } 
                                                                      '(' dList ')' '{' listacmd RETURN exp ';' '}'{ts = tabelaSimbolos;if($2 != $11)
                                                                          yyerror("Retorno nao eh o mesmo tipo definido na funcao");
                                                                      }
      ;
              //
              // faria mais sentido reconhecer todos os tipos como ident! 
              // 
type : INT    { $$ = Tipo.INT; }
     | DOUBLE  { $$ = Tipo.DOUBLE; }
     | BOOL   { $$ = Tipo.BOOL; }
     | STRUCT { $$ = Tipo.STRUCT;}
     ;



main :  VOID MAIN '(' ')' { currClass = "main"; }  bloco 
      | VOID IDENT '(' ')' { currClass = $2; } bloco
      |
;

bloco : '{' listacmd '}' main;

listacmd : listacmd cmd
        |
         ;

cmd :  exp ';' 
      | IF '(' exp ')' cmd   {  if ( ((Tipo)$3) != Tipo.BOOL) 
                                     yyerror("(sem) expressão (if) deve ser lógica "+((Tipo)$3).getTipo());
                             }  
      | decl  
       ;


exp : exp '+' exp { $$ = validaTipo('+', (Tipo)$1, (Tipo)$3); }
    | exp '>' exp { $$ = validaTipo('>', (Tipo)$1, (Tipo)$3); }
    | exp AND exp { $$ = validaTipo(AND, (Tipo)$1, (Tipo)$3); } 
    | NUM         { $$ = Tipo.INT; }      
    | '(' exp ')' { $$ = $2; }
    | lvalue   { $$ = $1; }                   
    | lvalue '=' exp  {  $$ = validaTipo(ATRIB, (Tipo)$1, (Tipo)$3);  } 
    ;


lvalue :  IDENT   { TS_entry nodo = ts.pesquisa($1);
                    if (nodo == null) {
                       yyerror("(sem) var <" + $1 + "> nao declarada"); 
                       $$ = Tipo.ERRO;    
                       }           
                    else
                        $$ = nodo.getTipo();
                  } 
       | IDENT '[' exp ']'  { TS_entry nodo = ts.pesquisa($1);
                              if (nodo == null) {
                                yyerror("(sem) var <" + $1 + "> nao declarada"); 
                                $$ = Tipo.ERRO;    
                              }           
                              else
                                $$ = nodo.getTipoArray();}

       | IDENT '.' IDENT      { TS_entry nodo = ts.pesquisa($1);
                              if (nodo == null) {
                                yyerror("(sem) struct <" + $1 + "> nao declarada"); 
                                $$ = Tipo.ERRO;    
                              }           
                              else if(nodo.getTipo() == Tipo.STRUCT){
                                  nodo = nodo.getTabelaSimb().pesquisa($3);
                                  if (nodo == null) {
                                    yyerror("(sem) tipo na struct <" + $3 + "> nao declarada"); 
                                    $$ = Tipo.ERRO;    
                                  }           
                                  else $$ = nodo.getTipo();
                                }
                              else $$ = Tipo.ERRO;
                              }
       | IDENT'(' lexep ')' {Collections.reverse(listaExec); $$ = validaTipoFunc(tf.pesquisa($1), listaExec); listaExec.clear();}
       ;

  lexep : exp ',' lexep {listaExec.add((Tipo)$1);}
        | exp {listaExec.add((Tipo)$1);}
        |
        ;
%%

  private Yylex lexer;

  private Tabelas ts;
  private TabSimb tabelaSimbolos;
  private TabFunc tf;
  private String temp;
  private ArrayList<Tipo> listaExec;

  public static final int ARRAY = 1500;
  public static final int ATRIB = 1600;

  private String currEscopo;
  private String currClass;

  private int yylex () {
    int yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e);
    }
    return yyl_return;
  }


  public void yyerror (String error) {
    //System.err.println("Erro (linha: "+ lexer.getLine() + ")\tMensagem: "+error);
    System.err.printf("Erro (linha: %2d \tMensagem: %s)\n", lexer.getLine(), error);
  }


  public Parser(Reader r) {
    lexer = new Yylex(r, this);

    tabelaSimbolos = new TabSimb();
    ts = tabelaSimbolos;
    tf = new TabFunc();
    listaExec = new ArrayList<Tipo>();
    

  }  

  public void setDebug(boolean debug) {
    yydebug = debug;
  }

  public void listarTS() {ts.listar();}
  public void listarTF() {tf.listar();}

  public static void main(String args[]) throws IOException {
    System.out.println("\n\nVerificador semantico simples\n");
    

    Parser yyparser;
    if ( args.length > 0 ) {
      // parse a file
      yyparser = new Parser(new FileReader(args[0]));
    }
    else {
      // interactive mode
      System.out.println("[Quit with CTRL-D]");
      System.out.print("Programa de entrada:\n");
        yyparser = new Parser(new InputStreamReader(System.in));
    }

    yyparser.yyparse();

      yyparser.listarTS();
      yyparser.listarTF();

      System.out.print("\n\nFeito!\n");
    
  }

    Tipo validaTipoFunc(Funcao funcao, ArrayList<Tipo> listaExec){
      ArrayList<TS_entry> func = funcao.getListaParams().getLista();
      ArrayList<Tipo> params = listaExec;
      if(func.size() != params.size()){
        yyerror("numero de parametros para execuçao esta incorreto");
         return Tipo.ERRO;
      }
      for(int i = 0; i<func.size(); i++){
        if(func.get(i).getTipo() != params.get(i)){
          yyerror("tipo " + i + " que é " + func.get(i).getTipo() + " diferente de " + params.get(i)+ " chamado.");
          return Tipo.ERRO;
        }
      }
      return funcao.getTipoRetorno();
    }

   Tipo validaTipo(int operador, Tipo A, Tipo B) {
       
  switch ( operador ) {
    case ATRIB:
          if ( (A == Tipo.INT && B == Tipo.INT)                        ||
               (A == Tipo.DOUBLE && (B == Tipo.INT || B == Tipo.DOUBLE)) ||
               (A == B) )
               return A;
           else
               yyerror("(sem) tipos incomp. para atribuicao: "+ A.getTipo() + " = "+B.getTipo());
          break;

    case '+' :
          if (A == Tipo.INT && B == Tipo.INT)
                return Tipo.INT;
          else if (   (A == Tipo.DOUBLE && (B == Tipo.INT || B == Tipo.DOUBLE)) ||
                      (B == Tipo.DOUBLE && (A == Tipo.INT || A == Tipo.DOUBLE)) ) 
               return Tipo.DOUBLE;     
          else
              yyerror("(sem) tipos incomp. para soma: "+ A.getTipo() + " + "+B.getTipo());
          break;

   case '>' :
           if ((A == Tipo.INT || A == Tipo.DOUBLE) && (B == Tipo.INT || B == Tipo.DOUBLE))
               return Tipo.BOOL;
            else
              yyerror("(sem) tipos incomp. para op relacional: "+ A.getTipo() + " > "+B.getTipo());
            break;

   case AND:
           if (A == Tipo.BOOL && B == Tipo.BOOL)
               return Tipo.BOOL;
            else
              yyerror("(sem) tipos incomp. para op lógica: "+ A.getTipo() + " && "+B.getTipo());
       break;
  }

  return Tipo.ERRO;
           
     }

