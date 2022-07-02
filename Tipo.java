public enum Tipo {
    INT("int"), 
    DOUBLE("double"), 
    STRUCT("struct"),
    BOOL("bool"),
    ERRO("_erro_");

    private String tipo;
  
    // getter method
    public String getTipo()
    {
        return this.tipo;
    }

    private Tipo(String tipo)
    {
        this.tipo = tipo;
    }
  }



