    
%{
  import java.io.*;
%}


%token IDENT, INT, DOUBLE, BOOL, NUM, STRING
%token LITERAL, AND, VOID, MAIN, IF
%token STRUCT

%right '='
%nonassoc '>'
%left '+'
%left AND
%left '[' 
%left '.'  

%type <sval> IDENT
%type <ival> NUM
%type <obj> type
%type <obj> exp
%type <obj> lvalue

%%

prog : { currClass = ClasseID.VarGlobal; } dList main ;

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
                                      ts.insert(new TS_entry($5, (Tipo)$1, currClass));
                                     }
                                   }
      ;
              //
              // faria mais sentido reconhecer todos os tipos como ident! 
              // 
type : INT    { $$ = Tipo.INT; }
     | DOUBLE  { $$ = Tipo.DOUBLE; }
     | BOOL   { $$ = Tipo.BOOL; }
     | STRUCT { $$ = Tipo.STRUCT;} 
     | IDENT  { TS_entry nodo = ts.pesquisa($1);
                if (nodo == null ) 
                   yyerror("(sem) Nome de tipo <" + $1 + "> nao declarado ");
                else 
                    $$ = nodo;
               } 
     ;



main :  VOID MAIN '(' ')' bloco ;

bloco : '{' listacmd '}';

listacmd : listacmd cmd
        |
         ;

cmd :  exp ';' 
      | IF '(' exp ')' cmd   {  if ( ((Tipo)$3) != Tipo.BOOL) 
                                     yyerror("(sem) expressão (if) deve ser lógica "+((Tipo)$3).getTipo());
                             }     
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
       | IDENT '[' exp ']'  { $$ = Tipo.ERRO; }
       | IDENT '.' exp      { $$ = Tipo.ERRO; }
%%

  private Yylex lexer;

  private TabSimb ts;

  public static final int ARRAY = 1500;
  public static final int ATRIB = 1600;

  private String currEscopo;
  private ClasseID currClass;

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

    ts = new TabSimb();
    

  }  

  public void setDebug(boolean debug) {
    yydebug = debug;
  }

  public void listarTS() { ts.listar();}

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

      System.out.print("\n\nFeito!\n");
    
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

