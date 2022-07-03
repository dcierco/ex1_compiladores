import java.util.ArrayList;
import java.util.List;

public class Funcao
{
   private String id;
   private String classe;  
   private Tipo tipoRetorno;
   private ListaParams listaParams;

   // construtor para arrays
   public Funcao(String id, Tipo tipoRetorno, String classe) {
      this.id = id;
      this.classe = classe;
      this.tipoRetorno = tipoRetorno;
      this.listaParams = new ListaParams();
   }

   public ListaParams getListaParams(){
    return this.listaParams;
   }

   public String getId() {
       return id; 
   }

   public Tipo getTipoRetorno() {
       return tipoRetorno; 
   }
   
    
   public String toString() {
    StringBuilder aux = new StringBuilder("");
     
    aux.append("Id: ");
    aux.append(String.format("%-10s", this.id));

    aux.append("\tClasse: ");
    aux.append(classe);
    aux.append("\tTipo do retorno: "); 
    aux.append(this.tipoRetorno.getTipo());
    aux.append("\t\tParametros: ");
    aux.append(this.listaParams.toString());
   return aux.toString();

}

}

