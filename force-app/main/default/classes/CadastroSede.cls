public with sharing class CadastroSede {
    @AuraEnabled
    public static String cadastroSede(String nomeSede , String endereco){
        try {
            
            Sede__c novoCadastro = new Sede__c();
            
            novoCadastro.Nome_da_Sede__c = nomeSede;
            novoCadastro.Endere_o__c = endereco;
            novoCadastro.Clientes_Cadastrados__c = 0;
            novoCadastro.Faturamento__c = 0;
            
            insert novoCadastro;
            return novoCadastro.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
}

}