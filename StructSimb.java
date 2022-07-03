import java.util.ArrayList;
import java.util.Iterator;


public class StructSimb implements Tabelas
{
    private ArrayList<TS_entry> lista;
    
    public StructSimb()
    {
        lista = new ArrayList<TS_entry>();
    }
    
     public void insert(TS_entry nodo) {
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

    public String toString() {
        StringBuilder aux = new StringBuilder("");
        for (TS_entry entry : lista) {
            aux.append("\t\t\t");
            aux.append("Id: ");
            aux.append(String.format("%-10s", entry.getId()));
            aux.append("\tTipo: "); 
            aux.append(entry.getTipo().getTipo()); 
            if(entry.getTipoArray() != null){
                aux.append("[" + entry.getTipoArray() + "] ");
            }
            aux.append("\n");
        }
       return aux.toString();
    }

    public  ArrayList<TS_entry> getLista() {return lista;}

    public void listar(){
        System.out.println("O compilador ta listando errado");
        return;
    }
}



