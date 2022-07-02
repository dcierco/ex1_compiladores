import java.util.ArrayList;
import java.util.List;

public class Funcao
{
   private String id;
   private String classe;  
   private Tipo tipoRetorno;
   private ListaParams listaParams;

   // construtor para arrays
   public Funcao(String id, Tipo tipoRetorno, ListaParams listaParams, String classe) {
      this.id = id;
      this.classe = classe;
      this.tipoRetorno = tipoRetorno;
      this.listaParams = listaParams;
   }


   public String getId() {
       return id; 
   }

   public Tipo getTipoRetorno() {
       return tipoRetorno; 
   }
   
    
   public String toString() {
        return "";
   }

