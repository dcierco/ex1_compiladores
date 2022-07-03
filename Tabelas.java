import java.util.ArrayList;
public interface Tabelas
{
    public void insert(TS_entry nodo); 
      
    public TS_entry pesquisa(String umId);

    public ArrayList<TS_entry> getLista();

    public void listar();
}



