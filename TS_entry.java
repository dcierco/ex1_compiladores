import java.util.ArrayList;
import java.util.List;
public class TS_entry
{
   private String id;
   private ClasseID classe;  
   private Tipo tipo;

   // construtor para arrays
   public TS_entry(String umId, Tipo umTipo, ClasseID umaClasse) {
      id = umId;
      classe = umaClasse;
      tipo = umTipo;
   }


   public String getId() {
       return id; 
   }

   public Tipo getTipo() {
       return tipo; 
   }
   
    
   public String toString() {
       StringBuilder aux = new StringBuilder("");
        
       aux.append("Id: ");
       aux.append(String.format("%-10s", id));

       aux.append("\tClasse: ");
       aux.append(classe);
       aux.append("\tTipo: "); 
       aux.append(this.tipo.getTipo()); 
       
      return aux.toString();

   }

  public String getTipoStr() {return tipo.getTipo();} 
   
}






