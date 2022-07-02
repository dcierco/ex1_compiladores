import java.util.ArrayList;
import java.util.Iterator;


public class TabFunc
{
    private ArrayList<Funcao> lista;
    
    public TabFunc( )
    {
        lista = new ArrayList<Funcao>();
    }
    
     public void insert(Funcao func) {
      lista.add(func);
    }    
    
    public void listar() {
      int cont = 0;  
      System.out.println("\n\nListagem da tabela de funções:\n");
      for (Funcao func : lista) {
          System.out.println(func);
      }
    }
      
    public Funcao pesquisa(String nomeFuncao) {
      for (Funcao func : lista) {
          if (func.getNome().equals(nomeFuncao)) {
	      return func;
        }
      }
      return null;
    }

    public  ArrayList<Funcao> getLista() {return lista;}
}
