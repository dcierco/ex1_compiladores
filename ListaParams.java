import java.util.ArrayList;

public class ListaParams implements Tabelas{
    private ArrayList<TS_entry> lista;
    
    public ListaParams()
    {
        lista = new ArrayList<TS_entry>();
    }
    
     public void insert(TS_entry nodo ) {
      lista.add(nodo);
    }
      
    public TS_entry pesquisa(String umId) {
      for (TS_entry nodo : lista) {
          if (nodo.getId().equals(umId)) {
	      return nodo;
            }
      }
      return null;
    }

    public void clear(){
      this.lista.clear();
    }

    public  ArrayList<TS_entry> getLista() {return lista;}

    public void listar(){
      System.out.println("Ficou no lugar errado");
    }

    @Override
    public String toString() {
      StringBuilder aux = new StringBuilder();
        for (TS_entry param : lista) {
          aux.append("\n\t\t\t\t\tNome do parametro: ");
          aux.append(param.getId());
          aux.append("\tTipo do parametro: ");
          aux.append(param.getTipoStr());
        }
        aux.append("\n");
        return aux.toString();
    }
}