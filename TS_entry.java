import java.util.ArrayList;
import java.util.List;
public class TS_entry
{
   private String id;
   private String classe;  
   private Tipo tipo;
   private Tipo tipoArray;
   private StructSimb simbolosStruct;

   // construtor para arrays
   public TS_entry(String id, Tipo tipo, String classe) {
      this.simbolosStruct = (tipo == Tipo.STRUCT) ? new StructSimb() : null;
      this.id = id;
      this.tipo = tipo;
      this.classe = classe;
      this.tipoArray = null;
    }

   public TS_entry(String id, Tipo tipo, String classe, Tipo tipoArray) {
    this.id = id;
    this.tipo = tipo;
    this.classe = classe;
    this.tipoArray = tipoArray;
    this.simbolosStruct = null;
 }

   public Tipo getTipoArray(){
        return this.tipoArray;
   }

   public String getId() {
       return this.id; 
   }

   public StructSimb getTabelaSimb(){
        return this.simbolosStruct;
   }

   public Tipo getTipo() {
       return this.tipo; 
   }
   
    
   public String toString() {
       StringBuilder aux = new StringBuilder("");
        
       aux.append("Id: ");
       aux.append(String.format("%-10s", id));

       aux.append("\tClasse: ");
       aux.append(classe);
       aux.append("\tTipo: "); 
       aux.append(this.tipo.getTipo());
       if(this.getTabelaSimb() != null){
            aux.append("\n\t\t{\n" + this.getTabelaSimb().toString() + "\t\t} ");
       }
       if(this.tipoArray != null){
        aux.append(": "+ this.tipoArray + "[]");
       }
       
      return aux.toString();

   }

  public String getTipoStr() {return tipo.getTipo();} 
   
}






